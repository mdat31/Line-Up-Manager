import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/lineup.dart';
import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/domain/entities/formations.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_cubit.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_state.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryTeamRepository teams;
  late InMemoryLineupRepository lineups;
  late Team team;
  late List<Player> players;

  setUp(() async {
    teams = InMemoryTeamRepository();
    lineups = InMemoryLineupRepository();
    (team, players) = await seedFiveASide(teams);
  });

  LineupCubit build() => LineupCubit(teams, lineups, team.id!);

  LineupReady ready(LineupCubit c) => c.state as LineupReady;

  test('first load auto-fills the default formation and persists it', () async {
    final cubit = build();
    await cubit.load();

    final state = ready(cubit);
    expect(state.lineup.formationId, '1-2-1');
    expect(state.lineup.starterIds, hasLength(5));
    expect(state.bench, hasLength(2));
    expect(lineups.lineups[team.id], state.lineup);
  });

  test('restores a saved line-up and prunes deleted players', () async {
    final cubit = build();
    await cubit.load();
    final keeperId = ready(cubit).lineup.slots[0].playerId!;
    await cubit.setCaptain(keeperId);
    await teams.deletePlayer(keeperId);

    final reloaded = build();
    await reloaded.load();
    expect(ready(reloaded).lineup.slots[0].playerId, isNull);
    expect(ready(reloaded).lineup.captainId, isNull);
  });

  test('a saved line-up for another format is replaced', () async {
    await lineups.saveLineup(
      const Lineup(teamId: 1, formationId: '4-4-2', slots: []),
    );
    final cubit = build();
    await cubit.load();
    expect(ready(cubit).lineup.formationId, '1-2-1');
  });

  blocTest<LineupCubit, LineupState>(
    'moving a slot emits and saves the new spot',
    build: build,
    act: (c) async {
      await c.load();
      await c.moveSlot(2, const SlotPosition(0.3, 0.3));
    },
    skip: 1,
    verify: (c) {
      expect(ready(c).lineup.slots[2].position, const SlotPosition(0.3, 0.3));
      expect(lineups.lineups[team.id]!.slots[2].position.x, 0.3);
    },
  );

  test('bench drop on grass takes the nearest slot', () async {
    final cubit = build();
    await cubit.load();
    final sub = ready(cubit).bench.first;
    final keeperSpot = ready(cubit).lineup.slots[0].position;

    await cubit.assignNearest(sub.id!, keeperSpot);

    expect(ready(cubit).lineup.slots[0].playerId, sub.id);
    expect(ready(cubit).bench, hasLength(2));
  });

  test('changing formation and reset', () async {
    final cubit = build();
    await cubit.load();
    final target = Formations.find(TeamFormat.fiveASide, '2-2')!;
    await cubit.changeFormation(target);
    await cubit.sendToBench(1);
    expect(ready(cubit).lineup.formationId, '2-2');
    expect(ready(cubit).bench, hasLength(3));

    await cubit.reset();
    expect(ready(cubit).lineup.formationId, '2-2');
    expect(ready(cubit).bench, hasLength(2));
  });

  test('no-op edits do not hit storage', () async {
    final cubit = build();
    await cubit.load();
    final before = lineups.saves;
    await cubit.swapSlots(1, 1);
    expect(lineups.saves, before);
  });

  test('toCard exports starters with captain and subs by short name', () async {
    final cubit = build();
    await cubit.load();
    final keeper = ready(cubit).lineup.slots[0].playerId!;
    await cubit.setCaptain(keeper);

    final card = ready(cubit).toCard();
    expect(card.teamName, 'FC Phủi');
    expect(card.starters, hasLength(5));
    expect(card.starters.first.name, 'An');
    expect(card.starters.first.isCaptain, isTrue);
    expect(card.substitutes, ['Phong', 'Giang']);
  });

  test('missing team fails', () async {
    final cubit = LineupCubit(teams, lineups, 999);
    await cubit.load();
    expect(cubit.state, isA<LineupFailure>());
  });

  // Keeps the seeded roster referenced so its order is part of the fixture.
  test('fixture sanity', () => expect(players, hasLength(7)));
}
