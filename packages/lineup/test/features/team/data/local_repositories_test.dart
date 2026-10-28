import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/src/core/database/lineup_database.dart';
import 'package:lineup/src/features/lineup/data/datasources/lineup_local_data_source.dart';
import 'package:lineup/src/features/lineup/data/repositories/lineup_repository_impl.dart';
import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';
import 'package:lineup/src/features/team/data/datasources/team_local_data_source.dart';
import 'package:lineup/src/features/team/data/repositories/team_repository_impl.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  late Database db;
  late TeamRepositoryImpl teams;
  late LineupRepositoryImpl lineups;

  setUp(() async {
    db = await LineupDatabase.open(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    teams = TeamRepositoryImpl(TeamLocalDataSource(db));
    lineups = LineupRepositoryImpl(LineupLocalDataSource(db));
  });

  tearDown(() => db.close());

  test('saves, updates and lists teams by name', () async {
    final b = await teams.saveTeam(
      const Team(name: 'b team', format: TeamFormat.sevenASide),
    );
    await teams.saveTeam(
      const Team(name: 'A Team', format: TeamFormat.fiveASide, coachName: 'X'),
    );
    await teams.saveTeam(b.copyWith(format: TeamFormat.elevenASide));

    final all = await teams.getTeams();
    expect(all.map((t) => t.name), ['A Team', 'b team']);
    expect(all.first.coachName, 'X');
    expect((await teams.getTeam(b.id!))!.format, TeamFormat.elevenASide);
  });

  test(
    'players round-trip and sort by shirt number, unnumbered last',
    () async {
      final team = await teams.saveTeam(
        const Team(name: 'T', format: TeamFormat.fiveASide),
      );
      final id = team.id!;
      await teams.savePlayer(Player(teamId: id, name: 'No number'));
      await teams.savePlayer(
        Player(
          teamId: id,
          name: 'Ten',
          number: 10,
          position: PlayerPosition.forward,
        ),
      );
      final one = await teams.savePlayer(
        Player(teamId: id, name: 'One', number: 1),
      );
      await teams.savePlayer(
        one.copyWith(position: PlayerPosition.goalkeeper, clearNumber: true),
      );

      final players = await teams.getPlayers(id);
      expect(players.map((p) => p.name), ['Ten', 'No number', 'One']);
      expect(players.last.position, PlayerPosition.goalkeeper);
      expect(players.last.number, isNull);
    },
  );

  test('line-up round-trips including empty slots and captain', () async {
    final team = await teams.saveTeam(
      const Team(name: 'T', format: TeamFormat.fiveASide),
    );
    final lineup = Lineup(
      teamId: team.id!,
      formationId: '2-2',
      captainId: 7,
      slots: const [
        LineupSlot(position: SlotPosition(0.5, 0.9), playerId: 7),
        LineupSlot(position: SlotPosition(0.25, 0.5)),
      ],
    );
    await lineups.saveLineup(lineup);
    await lineups.saveLineup(lineup.copyWith(formationId: '3-1'));

    final loaded = await lineups.getLineup(team.id!);
    expect(loaded, lineup.copyWith(formationId: '3-1'));
  });

  test('deleting a team cascades to players and line-up', () async {
    final team = await teams.saveTeam(
      const Team(name: 'T', format: TeamFormat.fiveASide),
    );
    await teams.savePlayer(Player(teamId: team.id!, name: 'A'));
    await lineups.saveLineup(
      Lineup(teamId: team.id!, formationId: '2-2', slots: const []),
    );

    await teams.deleteTeam(team.id!);

    expect(await teams.getPlayers(team.id!), isEmpty);
    expect(await lineups.getLineup(team.id!), isNull);
  });
}
