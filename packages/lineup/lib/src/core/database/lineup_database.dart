import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Opens the package's own SQLite file so it never collides with a host
/// app's database.
abstract final class LineupDatabase {
  static const fileName = 'lineup.db';
  static const _version = 1;

  /// [factory] and [path] exist for tests (FFI / in-memory databases).
  static Future<Database> open({DatabaseFactory? factory, String? path}) async {
    final dbFactory = factory ?? databaseFactory;
    final dbPath = path ?? p.join(await dbFactory.getDatabasesPath(), fileName);
    return dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _version,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) => _createV1(db),
      ),
    );
  }

  static Future<void> _createV1(Database db) async {
    final batch = db.batch()
      ..execute('''
        CREATE TABLE teams (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          format TEXT NOT NULL,
          coach_name TEXT NOT NULL DEFAULT ''
        )''')
      ..execute('''
        CREATE TABLE players (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
          name TEXT NOT NULL,
          number INTEGER,
          position TEXT NOT NULL
        )''')
      ..execute('CREATE INDEX idx_players_team ON players(team_id)')
      ..execute('''
        CREATE TABLE lineups (
          team_id INTEGER PRIMARY KEY REFERENCES teams(id) ON DELETE CASCADE,
          formation_id TEXT NOT NULL,
          slots TEXT NOT NULL,
          captain_id INTEGER
        )''');
    await batch.commit(noResult: true);
  }
}
