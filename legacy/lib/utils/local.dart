import 'package:flutter/cupertino.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/club/club_repository.dart';
import 'package:marozi/model/league/league.dart';
import 'package:marozi/model/league/league_repository.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/model/player/player_repository.dart';
import 'package:marozi/utils/database_helpers.dart';
import 'package:sqflite/sqflite.dart';

class MaroziLocal {
  Future<int> countLeagueLocal() async {
    final leagueRepo = LeagueRepository();
    return await leagueRepo.count();
  }

  Future<int> countClubByLeague({@required League league}) async {
    final clubRepo = ClubRepository();
    return await clubRepo.countClubByLeagueId(league: league);
  }

  Future<List<Club>> getClubsByLeague(League league) async {
    final clubRepo = ClubRepository();
    return await clubRepo.getClubsByLeague(league: league);
  }

  Future<List<Player>> getPlayersByClub(Club club) async {
    final playerRepo = PlayerRepository();
    return await playerRepo.getPlayersByClub(club: club);
  }

  Future<int> countPlayersByClub({@required Club club}) async {
    final playerRepo = PlayerRepository();
    return await playerRepo.countPlayersByClub(club);
  }

  Future insertLeagueLocal(League league) async {
    final leagueRepo = LeagueRepository();
    await leagueRepo.insertLeague(league);
  }

  Future clearAllContent() async {
    final helper = DatabaseHelper.instance;
    Database db = await helper.database;
    await db.delete(tableLeagues);
    await db.delete(tableClubs);
    await db.delete(tablePlayer);
    await db.delete(tableFavorite);
  }

  Future deleteDB() async {
    final helper = DatabaseHelper.instance;
    await helper.deleteDB();
  }
}
