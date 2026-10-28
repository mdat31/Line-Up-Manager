import 'package:flutter/cupertino.dart';
import 'package:marozi/model/favorite/favorite.dart';
import 'package:marozi/model/favorite/favorite_dao.dart';

class FavoriteRepository {
  final favDao = FavoriteDao();

  Future<bool> isFavorite({@required String playerId}) =>
      favDao.isFavorite(playerId);

  Future<Favorite> getFavorite({@required String playerId}) =>
      favDao.getFavorite(playerId);

  Future<List<Favorite>> getAllFavorite() => favDao.getAllFavorite();

  Future<int> insertFavorite({@required String playerId}) =>
      favDao.createFavorite(playerId);

  Future<int> deleteFavorite({@required String playerId}) =>
      favDao.deleteFavorite(playerId);
}
