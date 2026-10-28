import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';
import 'package:lineup/src/features/team/domain/repositories/team_repository.dart';
import 'package:lineup/src/features/team/presentation/team_detail/team_detail_state.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_state.dart';

class TeamDetailCubit extends Cubit<TeamDetailState> {
  TeamDetailCubit(this._teams, this.teamId) : super(const TeamDetailState());

  final TeamRepository _teams;
  final int teamId;

  Future<void> load() async {
    try {
      final team = await _teams.getTeam(teamId);
      if (team == null) {
        emit(state.copyWith(status: LoadStatus.failure));
        return;
      }
      final players = await _teams.getPlayers(teamId);
      emit(
        TeamDetailState(status: LoadStatus.ready, team: team, players: players),
      );
    } on Object {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  Future<void> saveTeam(Team team) async {
    await _teams.saveTeam(team);
    await load();
  }

  Future<void> savePlayer(Player player) async {
    await _teams.savePlayer(player);
    await load();
  }

  Future<void> deletePlayer(Player player) async {
    final id = player.id;
    if (id == null) return;
    await _teams.deletePlayer(id);
    await load();
  }
}
