import 'package:flutter/cupertino.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/model/player/player_dao.dart';

class PlayerRepository {
  final playerDao = PlayerDao();

  Future<List<Player>> getAllPlayer() => playerDao.getAllPlayers();

  Future insertPlayer(Player player) => playerDao.createPlayer(player);

  Future<int> countPlayersByClub(Club club) =>
      playerDao.countPlayersByClubId(club.id);

  Future<List<Player>> getPlayersByClub({Club club}) =>
      playerDao.getPlayersByClubId(club.id);

  Future<Player> getPlayer({@required String playerId}) =>
      playerDao.getPlayer(playerId);
}
