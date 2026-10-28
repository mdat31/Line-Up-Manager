import 'package:lineup/src/features/team/data/datasources/team_local_data_source.dart';
import 'package:lineup/src/features/team/data/models/player_model.dart';
import 'package:lineup/src/features/team/data/models/team_model.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';
import 'package:lineup/src/features/team/domain/repositories/team_repository.dart';

final class TeamRepositoryImpl implements TeamRepository {
  const TeamRepositoryImpl(this._local);

  final TeamLocalDataSource _local;

  @override
  Future<List<Team>> getTeams() async {
    final rows = await _local.queryTeams();
    return [for (final r in rows) TeamModel.fromMap(r).toEntity()];
  }

  @override
  Future<Team?> getTeam(int id) async {
    final row = await _local.queryTeam(id);
    return row == null ? null : TeamModel.fromMap(row).toEntity();
  }

  @override
  Future<Team> saveTeam(Team team) async {
    final row = TeamModel.fromEntity(team).toMap();
    if (team.id case final id?) {
      await _local.updateTeam(id, row);
      return team;
    }
    return team.copyWith(id: await _local.insertTeam(row));
  }

  @override
  Future<void> deleteTeam(int id) => _local.deleteTeam(id);

  @override
  Future<List<Player>> getPlayers(int teamId) async {
    final rows = await _local.queryPlayers(teamId);
    return [for (final r in rows) PlayerModel.fromMap(r).toEntity()];
  }

  @override
  Future<Player> savePlayer(Player player) async {
    final row = PlayerModel.fromEntity(player).toMap();
    if (player.id case final id?) {
      await _local.updatePlayer(id, row);
      return player;
    }
    return player.copyWith(id: await _local.insertPlayer(row));
  }

  @override
  Future<void> deletePlayer(int id) => _local.deletePlayer(id);
}
