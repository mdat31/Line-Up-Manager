import 'dart:io';

import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/league/league.dart';
import 'package:marozi/model/player/player.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// singleton class to manage the db
class DatabaseHelper {
  // Make this a singleton class.
  DatabaseHelper._();

  final String dbName = 'Marozi.db';
  final int dbVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._();

  // Only allow a single open connection to the db
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the db
  _initDatabase() async {
    // The path_provider plugin gets the right dir for Android or iOS
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    // Open the db. Can also add an onUpdate callback parameter
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  void _onCreate(Database db, int version) async {
    await _createTable(db);
  }

// Database helper methods:

  Future _createTable(Database db) async {
    await db.execute('''
    CREATE TABLE $tableLeagues(
    $leagueId TEXT PRIMARY KEY,
    $leagueName TEXT,
    $leagueNation TEXT,
    $leagueLogoUrl TEXT,
    $leagueIsExpand INTEGER
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableClubs(
    $clubId TEXT PRIMARY KEY,
    $clubName TEXT,
    $clubLeagueId TEXT,
    $clubLeagueName TEXT,
    $clubLogoUrl TEXT,
    $clubIsExpand INTEGER
    )
    ''');
    await db.execute('''
    CREATE TABLE $tablePlayer(
    $playerId TEXT PRIMARY KEY,
    $playerName TEXT,
    $playerAge TEXT,
    $playerClubId TEXT,
    $playerClubName TEXT,
    $playerPosition TEXT,
    $playerOverall TEXT,
    $playerPotential TEXT,
    $playerNumber TEXT,
    $playerNation TEXT,
    $playerWage TEXT,
    $playerFootPrefer TEXT,
    $playerBirthday TEXT,
    $playerWeight TEXT,
    $playerHeight TEXT,
    $playerAvatarUrl TEXT,
    $playerBallSkill TEXT,
    $playerDefence TEXT,
    $playerShooting TEXT,
    $playerPhysical TEXT,
    $playerPassing TEXT,
    $playerIsExpand TEXT,
    $playerOffset TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableFavorite(
    $playerId TEXT PRIMARY KEY,
    $playerName TEXT,
    $playerAvatarUrl TEXT
    )
    ''');
  }

  Future deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    deleteDatabase(path);
  }

  Future<bool> dbExist() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return databaseExists(path);
  }
}
