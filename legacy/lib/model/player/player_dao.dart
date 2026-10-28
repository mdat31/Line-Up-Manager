import 'package:marozi/model/player/player.dart';
import 'package:marozi/utils/database_helpers.dart';
import 'package:sqflite/sqflite.dart';

class PlayerDao {
  DatabaseHelper helper = DatabaseHelper.instance;

  Future<int> createPlayer(Player player) async {
    Database db = await helper.database;
    int result = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tablePlayer WHERE $playerId = \'${player.id}\''));
    if (result < 1) {
      result = await db.insert(tablePlayer, player.toMap());
    }
    return result;
  }

  Future<List<Player>> getAllPlayers() async {
    Database db = await helper.database;
    List<Map<String, dynamic>> result;
    try {
      result = await db.query(tablePlayer);
    } catch (e) {
      print(e);
    }
    List<Player> listPlayer = result.isNotEmpty
        ? result.map((item) => Player.fromMap(item)).toList()
        : [];
    return listPlayer;
  }

  Future<int> countPlayersByClubId(String clubId) async {
    Database db = await helper.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT() from $tablePlayer WHERE club_id = \'$clubId\''));
  }

  Future<List<Player>> getPlayersByClubId(String clubId) async {
    Database db = await helper.database;
    List<Map<String, dynamic>> result;
    result =
        await db.query(tablePlayer, where: 'club_id = ?', whereArgs: [clubId]);
    List<Player> players =
        result.isNotEmpty ? result.map((e) => Player.fromMap(e)).toList() : [];
    return players;
  }

  Future<Player> getPlayer(String playerId) async {
    Database db = await helper.database;
    List<Map<String, dynamic>> result;
    result =
        await db.query(tablePlayer, where: 'id = ?', whereArgs: [playerId]);
    return result.isNotEmpty ? Player.fromMap(result[0]) : Player();
  }
}
