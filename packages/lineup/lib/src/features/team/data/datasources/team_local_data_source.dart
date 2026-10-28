import 'package:sqflite/sqflite.dart';

/// Raw SQL access for teams and players.
final class TeamLocalDataSource {
  const TeamLocalDataSource(this._db);

  final Database _db;

  Future<List<Map<String, Object?>>> queryTeams() =>
      _db.query('teams', orderBy: 'name COLLATE NOCASE');

  Future<Map<String, Object?>?> queryTeam(int id) async {
    final rows = await _db.query('teams', where: 'id = ?', whereArgs: [id]);
    return rows.firstOrNull;
  }

  Future<int> insertTeam(Map<String, Object?> row) => _db.insert('teams', row);

  Future<void> updateTeam(int id, Map<String, Object?> row) =>
      _db.update('teams', row, where: 'id = ?', whereArgs: [id]);

  Future<void> deleteTeam(int id) =>
      _db.delete('teams', where: 'id = ?', whereArgs: [id]);

  Future<List<Map<String, Object?>>> queryPlayers(int teamId) => _db.query(
    'players',
    where: 'team_id = ?',
    whereArgs: [teamId],
    orderBy: 'number IS NULL, number, name COLLATE NOCASE',
  );

  Future<int> insertPlayer(Map<String, Object?> row) =>
      _db.insert('players', row);

  Future<void> updatePlayer(int id, Map<String, Object?> row) =>
      _db.update('players', row, where: 'id = ?', whereArgs: [id]);

  Future<void> deletePlayer(int id) =>
      _db.delete('players', where: 'id = ?', whereArgs: [id]);
}
