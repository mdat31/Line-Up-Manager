import 'package:marozi/utils/database_helpers.dart';
import 'package:sqflite/sqflite.dart';

import 'league.dart';

class LeagueDao {
  final DatabaseHelper helper = DatabaseHelper.instance;

  Future<int> createLeague(League league) async {
    final db = await helper.database;
    int result = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tableLeagues WHERE id = \'${league.id}\''));

    if (result < 1) {
      result = await db.insert(tableLeagues, league.toMap());
    }
    return result;
  }

  Future<int> count() async {
    final db = await helper.database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableLeagues'));
    return count;
  }

  Future<List<String>> getNations() async {
    final db = await helper.database;
    List<Map<String, dynamic>> result;

    result = await db.query(tableLeagues, columns: ['nation'], distinct: true);

    List<String> nations = [];
    result.forEach((element) {
      element.forEach((key, value) {
        nations.add(value);
      });
    });
    return nations;
  }

  Future<Map<String, List<League>>> getLeagueByNation() async {
    final db = await helper.database;
    Map<String, List<League>> result = Map();
    List<Map<String, dynamic>> data;

    data = await db.query(tableLeagues);

    for (var map in data) {
      result[map['nation']] = [];
    }

    for (String nation in result.keys) {
      for (var map in data) {
        if (nation == map['nation']) {
          result[map['nation']].add(League.fromMap(map));
        }
      }
    }

    return result;
  }

  Future<List<League>> getLeagues({List<String> columns, String query}) async {
    final db = await helper.database;
    List<Map<String, dynamic>> result;
    try {
      if (query != null) {
        if (query.isNotEmpty) {
          result = await db.query(tableLeagues,
              columns: columns, where: 'id = ?', whereArgs: ['$query']);
        }
      } else if (query == null) {
        result = await db.query(tableLeagues, columns: columns);
      }
    } catch (e) {
      print('############################# getLeagues Error');
    }
    List<League> leagues = result.isNotEmpty && result != null
        ? result.map((item) => League.fromMap(item)).toList()
        : [];
    return leagues;
  }

  Future<int> updateLeague(League league) async {
    final db = await helper.database;

    var result = await db.update(tableLeagues, league.toMap(),
        where: 'id = ?', whereArgs: [league.id]);
    return result;
  }

  Future clearContent() async {
    final db = await helper.database;
    db.execute('DELETE FROM $tableLeagues');
  }

  Future<int> deleteLeague(League league) async {
    final db = await helper.database;

    return await db
        .delete(tableLeagues, where: 'id = ?', whereArgs: ['${league.id}']);
  }
}
