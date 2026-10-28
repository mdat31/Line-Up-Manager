import 'package:flutter/cupertino.dart';
import 'package:marozi/utils/database_helpers.dart';
import 'package:sqflite/sqflite.dart';

import 'club.dart';

class ClubDao {
  final helper = DatabaseHelper.instance;

  Future<int> createClub(Club club) async {
    final db = await helper.database;
    int result = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) from $tableClubs WHERE id = \'${club.id}\''));
    if (result < 1) {
      result = await db.insert(tableClubs, club.toMap());
    }
    return result;
  }

  Future<int> countClubByLeagueId(String leagueId) async {
    final db = await helper.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) from $tableClubs WHERE league_id = \'$leagueId\''));
  }

  Future<List<Club>> getClubsByLeagueId({@required String leagueId}) async {
    final db = await helper.database;
    List<Map<String, dynamic>> result;
    result = await db.query(
      tableClubs,
      where: 'league_id = ?',
      whereArgs: ['$leagueId'],
    );
    List<Club> clubs =
        result.isNotEmpty ? result.map((e) => Club.fromMap(e)).toList() : [];
    return clubs;
  }

  Future<List<Club>> getAllClubs() async {
    final db = await helper.database;
    List<Map<String, dynamic>> result;
    result = await db.query(tableClubs);
    List<Club> clubs =
        result.isNotEmpty ? result.map((e) => Club.fromMap(e)).toList() : [];
    return clubs;
  }

  Future<int> updateClub(Club club) async {
    final db = await helper.database;
    var result = db.update(tableClubs, club.toMap());
    return result;
  }

  Future<int> deleteClub(Club club) async {
    final db = await helper.database;
    return await db
        .delete(tableClubs, where: 'id = ?', whereArgs: ['${club.id}']);
  }

  Future<String> getAColOfClub(String clubId, {List<String> columns}) async {
    final db = await helper.database;
    List<Map<String, dynamic>> result;
    result = await db.query(tableClubs,
        columns: columns ?? [], where: 'id = ?', whereArgs: [clubId]);
    String str = result[0][columns[0]] ?? '';
    return str;
  }
}
