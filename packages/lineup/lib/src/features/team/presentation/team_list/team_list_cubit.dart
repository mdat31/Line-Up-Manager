import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';
import 'package:lineup/src/features/team/domain/repositories/team_repository.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_state.dart';

class TeamListCubit extends Cubit<TeamListState> {
  TeamListCubit(this._teams) : super(const TeamListState());

  final TeamRepository _teams;

  Future<void> load() async {
    try {
      final teams = await _teams.getTeams();
      emit(state.copyWith(status: LoadStatus.ready, teams: teams));
    } on Object {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  /// Returns the saved team so the caller can open it straight away.
  Future<Team> save(Team team) async {
    final saved = await _teams.saveTeam(team);
    await load();
    return saved;
  }

  Future<void> delete(Team team) async {
    final id = team.id;
    if (id == null) return;
    await _teams.deleteTeam(id);
    await load();
  }
}
