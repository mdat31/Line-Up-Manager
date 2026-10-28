import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

/// Source of teams and their rosters. Hosts may supply their own
/// implementation (e.g. backed by a remote roster) instead of the local one.
abstract interface class TeamRepository {
  Future<List<Team>> getTeams();

  Future<Team?> getTeam(int id);

  /// Inserts when [Team.id] is null, updates otherwise; returns the saved team.
  Future<Team> saveTeam(Team team);

  /// Also removes the team's players and line-up.
  Future<void> deleteTeam(int id);

  Future<List<Player>> getPlayers(int teamId);

  /// Inserts when [Player.id] is null, updates otherwise.
  Future<Player> savePlayer(Player player);

  Future<void> deletePlayer(int id);
}
