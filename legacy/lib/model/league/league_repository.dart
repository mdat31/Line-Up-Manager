import 'league.dart';
import 'league_dao.dart';

class LeagueRepository {
  final leagueDao = LeagueDao();

  Future getAllLeagues({String query}) => leagueDao.getLeagues(query: query);

  Future<Map<String, List<League>>> getLeagueByNation() =>
      leagueDao.getLeagueByNation();

  Future<int> count() => leagueDao.count();

  Future insertLeague(League league) => leagueDao.createLeague(league);

  Future updateLeague(League league) => leagueDao.updateLeague(league);

  Future clearContent() => leagueDao.clearContent();

  Future deleteLeagueById(League league) => leagueDao.deleteLeague(league);
}
