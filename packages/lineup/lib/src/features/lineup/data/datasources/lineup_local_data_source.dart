import 'package:sqflite/sqflite.dart';

final class LineupLocalDataSource {
  const LineupLocalDataSource(this._db);

  final Database _db;

  Future<Map<String, Object?>?> queryLineup(int teamId) async {
    final rows = await _db.query(
      'lineups',
      where: 'team_id = ?',
      whereArgs: [teamId],
    );
    return rows.firstOrNull;
  }

  Future<void> upsertLineup(Map<String, Object?> row) =>
      _db.insert('lineups', row, conflictAlgorithm: ConflictAlgorithm.replace);
}
