import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/domain/entities/formations.dart';
import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';
import 'package:lineup/src/features/lineup/domain/lineup_editor.dart';
import 'package:lineup/src/features/lineup/domain/repositories/lineup_repository.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_state.dart';
import 'package:lineup/src/features/team/domain/repositories/team_repository.dart';

class LineupCubit extends Cubit<LineupState> {
  LineupCubit(this._teams, this._lineups, this.teamId)
    : super(const LineupLoading());

  final TeamRepository _teams;
  final LineupRepository _lineups;
  final int teamId;

  Future<void> load() async {
    try {
      final team = await _teams.getTeam(teamId);
      if (team == null) return emit(const LineupFailure());
      final players = await _teams.getPlayers(teamId);
      final saved = await _lineups.getLineup(teamId);
      final rosterIds = {for (final p in players) ?p.id};
      // A saved line-up for another format (team edited 7 -> 5) is unusable.
      final formation = saved == null
          ? null
          : Formations.find(team.format, saved.formationId);
      final lineup = saved != null && formation != null
          ? LineupEditor.prune(saved, rosterIds)
          : LineupEditor.create(
              teamId,
              Formations.defaultFor(team.format),
              players,
            );
      emit(LineupReady(team: team, players: players, lineup: lineup));
      if (lineup != saved) await _lineups.saveLineup(lineup);
    } on Object {
      emit(const LineupFailure());
    }
  }

  Future<void> changeFormation(Formation formation) =>
      _edit((l) => LineupEditor.changeFormation(l, formation));

  /// Drop on empty grass: the slot follows the finger.
  Future<void> moveSlot(int slot, SlotPosition position) =>
      _edit((l) => LineupEditor.move(l, slot, position));

  /// Drop one token onto another: they trade places.
  Future<void> swapSlots(int from, int to) =>
      _edit((l) => LineupEditor.swap(l, from, to));

  Future<void> assign(int slot, int playerId) =>
      _edit((l) => LineupEditor.assign(l, slot, playerId));

  /// Bench player dropped on grass rather than on a token: take the
  /// closest slot so the drop never silently fails.
  Future<void> assignNearest(int playerId, SlotPosition position) => _edit(
    (l) =>
        LineupEditor.assign(l, LineupEditor.nearestSlot(l, position), playerId),
  );

  Future<void> sendToBench(int slot) =>
      _edit((l) => LineupEditor.clearSlot(l, slot));

  Future<void> setCaptain(int? playerId) =>
      _edit((l) => LineupEditor.setCaptain(l, playerId));

  /// Re-runs auto-fill on the current formation.
  Future<void> reset() => _edit((l) {
    final current = state as LineupReady;
    final formation =
        Formations.find(current.team.format, l.formationId) ??
        Formations.defaultFor(current.team.format);
    return LineupEditor.create(teamId, formation, current.players);
  });

  Future<void> _edit(Lineup Function(Lineup) change) async {
    final current = state;
    if (current is! LineupReady) return;
    final next = change(current.lineup);
    if (next == current.lineup) return;
    emit(current.withLineup(next));
    await _lineups.saveLineup(next);
  }
}
