import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';

/// Pure line-up transformations, kept out of the cubit so the rules are
/// testable without widgets or storage.
abstract final class LineupEditor {
  /// New line-up auto-filled by role: each slot first takes the
  /// lowest-numbered player of its own role, then any slot still empty takes
  /// the leftover player whose role is closest (a defender before a forward
  /// for a midfield gap).
  static Lineup create(int teamId, Formation formation, List<Player> players) {
    final pool = [...players]..sort(_byPositionThenNumber);
    final picks = List<int?>.filled(formation.positions.length, null);
    for (var i = 0; i < picks.length; i++) {
      final match = pool.indexWhere((p) => p.position == formation.roles[i]);
      if (match != -1) picks[i] = pool.removeAt(match).id;
    }
    for (var i = 0; i < picks.length && pool.isNotEmpty; i++) {
      if (picks[i] != null) continue;
      final role = formation.roles[i].index;
      var best = 0;
      for (var j = 1; j < pool.length; j++) {
        final d = (pool[j].position.index - role).abs();
        if (d < (pool[best].position.index - role).abs()) best = j;
      }
      picks[i] = pool.removeAt(best).id;
    }
    return Lineup(
      teamId: teamId,
      formationId: formation.id,
      slots: [
        for (var i = 0; i < picks.length; i++)
          LineupSlot(position: formation.positions[i], playerId: picks[i]),
      ],
    );
  }

  /// Keeps who plays in which slot index but resets every slot to the new
  /// formation's default spot, so custom drags do not leak across shapes.
  static Lineup changeFormation(Lineup lineup, Formation formation) {
    final slots = [
      for (var i = 0; i < formation.positions.length; i++)
        LineupSlot(
          position: formation.positions[i],
          playerId: i < lineup.slots.length ? lineup.slots[i].playerId : null,
        ),
    ];
    return _keepCaptainIfStarting(
      lineup.copyWith(formationId: formation.id, slots: slots),
    );
  }

  static Lineup move(Lineup lineup, int slot, SlotPosition position) {
    return _replaceSlot(
      lineup,
      slot,
      lineup.slots[slot].copyWith(position: position.clamped()),
    );
  }

  /// Swaps the players of two slots; the spots stay where they are.
  static Lineup swap(Lineup lineup, int a, int b) {
    if (a == b) return lineup;
    final slots = [...lineup.slots];
    final first = slots[a].playerId;
    final second = slots[b].playerId;
    slots[a] = slots[a].copyWith(playerId: second, clear: second == null);
    slots[b] = slots[b].copyWith(playerId: first, clear: first == null);
    return lineup.copyWith(slots: slots);
  }

  /// Puts [playerId] into [slot]. A player already starting elsewhere swaps
  /// with the current occupant; otherwise the occupant goes to the bench.
  static Lineup assign(Lineup lineup, int slot, int playerId) {
    final current = lineup.slots.indexWhere((s) => s.playerId == playerId);
    if (current != -1) return swap(lineup, current, slot);
    final updated = _replaceSlot(
      lineup,
      slot,
      lineup.slots[slot].copyWith(playerId: playerId),
    );
    return _keepCaptainIfStarting(updated);
  }

  static Lineup clearSlot(Lineup lineup, int slot) {
    final updated = _replaceSlot(
      lineup,
      slot,
      lineup.slots[slot].copyWith(clear: true),
    );
    return _keepCaptainIfStarting(updated);
  }

  /// Only starters can captain; anything else clears the armband.
  static Lineup setCaptain(Lineup lineup, int? playerId) {
    if (playerId == null || !lineup.starterIds.contains(playerId)) {
      return lineup.copyWith(clearCaptain: true);
    }
    return lineup.copyWith(captainId: playerId);
  }

  /// Drops references to players that no longer exist in the roster.
  static Lineup prune(Lineup lineup, Set<int> rosterIds) {
    final slots = [
      for (final s in lineup.slots)
        if (s.playerId case final id? when !rosterIds.contains(id))
          s.copyWith(clear: true)
        else
          s,
    ];
    return _keepCaptainIfStarting(lineup.copyWith(slots: slots));
  }

  static int nearestSlot(Lineup lineup, SlotPosition position) {
    var best = 0;
    var bestDistance = double.infinity;
    for (var i = 0; i < lineup.slots.length; i++) {
      final d = lineup.slots[i].position.distanceSquaredTo(position);
      if (d < bestDistance) {
        best = i;
        bestDistance = d;
      }
    }
    return best;
  }

  static Lineup _replaceSlot(Lineup lineup, int index, LineupSlot slot) {
    final slots = [...lineup.slots];
    slots[index] = slot;
    return lineup.copyWith(slots: slots);
  }

  static Lineup _keepCaptainIfStarting(Lineup lineup) {
    final captain = lineup.captainId;
    if (captain == null || lineup.starterIds.contains(captain)) return lineup;
    return lineup.copyWith(clearCaptain: true);
  }

  static int _byPositionThenNumber(Player a, Player b) {
    final byPosition = a.position.index.compareTo(b.position.index);
    if (byPosition != 0) return byPosition;
    return (a.number ?? 999).compareTo(b.number ?? 999);
  }
}
