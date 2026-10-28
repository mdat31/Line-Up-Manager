import 'package:marozi/model/favorite/favorite.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/utils/database_helpers.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDao {
  final helper = DatabaseHelper.instance;

  Future<bool> isFavorite(String playerId) async {
    Database db = await helper.database;
    List<Map<String, dynamic>> result =
        await db.query(tableFavorite, where: 'id = ?', whereArgs: [playerId]);
    return result.isNotEmpty ? true : false;
  }

  Future<int> createFavorite(String playerId) async {
    Database db = await helper.database;
    List<Map<String, dynamic>> players = await db.query(tablePlayer,
        columns: ['id', 'name', 'avatar_url'],
        where: 'id = ?',
        whereArgs: [playerId]);
    var fav = Favorite.fromMap(players[0]);
    return await db.insert(tableFavorite, fav.toMap());
  }

  Future<Favorite> getFavorite(String playerId) async {
    Database db = await helper.database;
    List<Map<String, dynamic>> result;
    result =
        await db.query(tableFavorite, where: 'id = ?', whereArgs: [playerId]);
    return result.isNotEmpty ? Favorite.fromMap(result[0]) : Favorite();
  }

  Future<List<Favorite>> getAllFavorite() async {
    Database db = await helper.database;
    List<Map<String, dynamic>> result;
    result = await db.query(tableFavorite);
    return result.isNotEmpty
        ? result.map((e) => Favorite.fromMap(e)).toList()
        : [];
  }

  Future<int> deleteFavorite(String playerId) async {
    Database db = await helper.database;
    return await db
        .delete(tableFavorite, where: 'id = ?', whereArgs: [playerId]);
  }
}
