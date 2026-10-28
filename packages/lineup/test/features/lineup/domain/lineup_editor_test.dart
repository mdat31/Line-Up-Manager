import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/domain/entities/formations.dart';
import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';
import 'package:lineup/src/features/lineup/domain/lineup_editor.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

Player _p(int id, PlayerPosition pos, [int? number]) =>
    Player(id: id, teamId: 1, name: 'P$id', number: number, position: pos);

void main() {
  final five = Formations.defaultFor(TeamFormat.fiveASide);
  final roster = [
    _p(1, PlayerPosition.forward, 9),
    _p(2, PlayerPosition.goalkeeper, 1),
    _p(3, PlayerPosition.defender, 4),
    _p(4, PlayerPosition.midfielder, 8),
    _p(5, PlayerPosition.midfielder, 6),
    _p(6, PlayerPosition.forward, 10),
  ];
  late Lineup lineup;

  setUp(() => lineup = LineupEditor.create(1, five, roster));

  group('create', () {
    test('puts each player in a slot of their own role, by shirt number', () {
      expect(lineup.slots.map((s) => s.playerId), [2, 3, 5, 4, 1]);
      expect(lineup.formationId, five.id);
    });

    test('fills a role gap with the closest remaining role', () {
      final noMidfield = [
        _p(1, PlayerPosition.goalkeeper, 1),
        _p(2, PlayerPosition.defender, 2),
        _p(3, PlayerPosition.defender, 3),
        _p(4, PlayerPosition.forward, 9),
        _p(5, PlayerPosition.forward, 10),
      ];
      final filled = LineupEditor.create(1, five, noMidfield);
      // 1-2-1: GK, DF, MF, MF, FW. Spare defender and forward cover midfield.
      expect(filled.slots.map((s) => s.playerId), [1, 2, 3, 5, 4]);
    });

    test('leaves slots empty when the roster is short', () {
      final short = LineupEditor.create(1, five, roster.take(2).toList());
      expect(short.slots.where((s) => s.playerId == null), hasLength(3));
    });
  });

  test('swap trades players but keeps spots', () {
    final swapped = LineupEditor.swap(lineup, 0, 4);
    expect(swapped.slots[0].playerId, 1);
    expect(swapped.slots[4].playerId, 2);
    expect(swapped.slots[0].position, lineup.slots[0].position);
  });

  test('swap with an empty slot moves the player there', () {
    final cleared = LineupEditor.clearSlot(lineup, 4);
    final swapped = LineupEditor.swap(cleared, 0, 4);
    expect(swapped.slots[0].playerId, isNull);
    expect(swapped.slots[4].playerId, 2);
  });

  test('move clamps to the pitch', () {
    final moved = LineupEditor.move(lineup, 1, const SlotPosition(1.4, -0.2));
    expect(moved.slots[1].position, const SlotPosition(1, 0));
  });

  group('assign', () {
    test('bench player replaces the occupant, who goes to the bench', () {
      final next = LineupEditor.assign(lineup, 4, 6);
      expect(next.slots[4].playerId, 6);
      expect(next.starterIds, isNot(contains(1)));
    });

    test('a starter assigned elsewhere swaps instead of duplicating', () {
      final next = LineupEditor.assign(lineup, 4, 2);
      expect(next.slots[4].playerId, 2);
      expect(next.slots[0].playerId, 1);
      expect(next.starterIds, hasLength(5));
    });
  });

  group('captain', () {
    test('only a starter can captain', () {
      expect(LineupEditor.setCaptain(lineup, 6).captainId, isNull);
      expect(LineupEditor.setCaptain(lineup, 3).captainId, 3);
    });

    test('benching the captain clears the armband', () {
      final withCaptain = LineupEditor.setCaptain(lineup, 3);
      expect(LineupEditor.clearSlot(withCaptain, 1).captainId, isNull);
    });
  });

  test('changeFormation keeps players per slot and resets spots', () {
    final moved = LineupEditor.move(lineup, 1, const SlotPosition(0.1, 0.1));
    final target = Formations.forFormat(TeamFormat.fiveASide)[1];
    final next = LineupEditor.changeFormation(moved, target);
    expect(next.formationId, target.id);
    expect(next.slots.map((s) => s.playerId), [2, 3, 5, 4, 1]);
    expect(next.slots[1].position, target.positions[1]);
  });

  test('prune drops deleted players and their captaincy', () {
    final withCaptain = LineupEditor.setCaptain(lineup, 3);
    final next = LineupEditor.prune(withCaptain, {1, 2, 4, 5});
    expect(next.slots[1].playerId, isNull);
    expect(next.captainId, isNull);
  });

  test('nearestSlot picks the closest spot', () {
    final keeper = lineup.slots[0].position;
    expect(
      LineupEditor.nearestSlot(
        lineup,
        SlotPosition(keeper.x + 0.02, keeper.y - 0.01),
      ),
      0,
    );
  });
}
