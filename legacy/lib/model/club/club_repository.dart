import 'package:flutter/cupertino.dart';
import 'package:marozi/model/league/league.dart';

import 'club.dart';
import 'club_dao.dart';

class ClubRepository {
  final clubDao = ClubDao();

  Future insertClub(Club club) => clubDao.createClub(club);

  Future<List<Club>> getClubsByLeague({@required League league}) =>
      clubDao.getClubsByLeagueId(leagueId: league.id);

  Future<int> countClubByLeagueId({@required League league}) =>
      clubDao.countClubByLeagueId(league.id);

  Future getAllClubs() => clubDao.getAllClubs();

  Future<String> getAColOfClub(
          {@required String clubId, List<String> columns}) =>
      clubDao.getAColOfClub(clubId, columns: columns);

  Future updateClub(Club club) => clubDao.updateClub(club);

  Future deleteClub(Club club) => clubDao.deleteClub(club);
}
