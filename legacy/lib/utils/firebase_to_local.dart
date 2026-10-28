import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/club/club_repository.dart';
import 'package:marozi/model/league/league.dart';
import 'package:marozi/model/league/league_repository.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/model/player/player_repository.dart';
import 'package:marozi/utils/local.dart';
import 'package:marozi/utils/log_in_service.dart';

class FirebaseToLocal {
  static final _maroziFirebase = LogInService();
  static final _maroziLocal = MaroziLocal();
  static final leagueRepo = LeagueRepository();
  static final clubRepo = ClubRepository();
  static final playerRepo = PlayerRepository();
  static final _firestoreInstance = FirebaseFirestore.instance;

  static Future splashDataLoading() async {
    await _maroziFirebase.getCurrentUser();
    if (await _leagueNeedUpdate()) {
      await _localUpdateAllLeague();
    }
  }

  static Future<bool> _leagueNeedUpdate() async {
    int firebase = await countLeagueFirebase();
    int local;
    try {
      local = await leagueRepo.count();
    } on Exception {
      local = 0;
    }
    return (local == 0 || local != firebase);
  }

  static _localUpdateAllLeague() async {
    await _firestoreInstance
        .collection('League')
        .orderBy('league_nation')
        .orderBy('league_name')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        var gsUrl = element.data()['league_logo_url'];
        League league = League();
        league.id = element.id;
        league.name = element.data()['league_name'];
        league.nation = element.data()['league_nation'];
        league.logoUrl = gsUrl != null && gsUrl != ''
            ? await FirebaseStorage.instance.getReferenceFromUrl(gsUrl).then(
                (StorageReference ref) => ref
                    .getDownloadURL()
                    .then((dynamic snapshot) => snapshot.toString()))
            : '';
        league.isExpand = false;
        await _maroziLocal.insertLeagueLocal(league);
      }
    });
  }

  Future<Map<String, List<League>>> getLeagueByNation() async {
    Map<String, List<League>> result = {};
    final leagueRepo = LeagueRepository();
    result = await leagueRepo.getLeagueByNation();
    return result;
  }

  Future<List<Club>> getClubsByLeague(League league) async {
    int local = await _maroziLocal.countClubByLeague(league: league);
    List<Club> clubsByLeague = await _getClubsByLeague(league);
    if (local == 0 || local != clubsByLeague.length) {
      clubsByLeague.forEach((club) {
        clubRepo.insertClub(club);
      });
    } else {
      return clubsByLeague;
    }
    return clubsByLeague;
  }

  Future<List<Club>> _getClubsByLeague(League league) async {
    List<Club> clubs = [];
    await _firestoreInstance
        .collection('Club')
        .orderBy('club_name')
        .where('league_id', isEqualTo: league.id)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        var gsUrl = element.data()['club_logo_url'];
        Club club = Club();
        club.id = element.id;
        club.name = element.data()['club_name'];
        club.leagueId = element.data()['league_id'];
        club.leagueName = element.data()['league_name'];
        club.logoUrl = gsUrl != null && gsUrl != ''
            ? await FirebaseStorage.instance.getReferenceFromUrl(gsUrl).then(
                (StorageReference ref) => ref
                    .getDownloadURL()
                    .then((dynamic snapshot) => snapshot.toString()))
            : '';
        club.isExpand = false;
        clubs.add(club);
      }
    });
    return clubs;
  }

  Future<List<Player>> getPlayersByClub(Club club) async {
    int local = await _maroziLocal.countPlayersByClub(club: club);
    List<Player> playersByClub = await _playersByClubFirebase(club);
    int firebase = playersByClub.length;
    if (local == 0 || local != firebase) {
      playersByClub.forEach((player) {
        playerRepo.insertPlayer(player);
      });
    } else {
      return playersByClub;
    }
    return playersByClub;
  }

  Future<List<Player>> _playersByClubFirebase(Club club) async {
    List<Player> players = [];
    await _firestoreInstance
        .collection('Player')
        .orderBy('player_name')
        .where('club_id', isEqualTo: club.id)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        var gsUrl = element.data()['player_avatar_url'];
        Player player = Player();
        player.id = element.id;
        player.name = element.data()['player_name'];
        player.clubId = element.data()['club_id'];
        player.clubName = element.data()['club_name'];
        player.age = element.data()['date_of_birth_age'];
        player.position = element.data()['position'];
        Map<String, dynamic> ovr = element.data()['overall_potential'] ?? {};
        player.overall = ovr['ovr'];
        player.potential = ovr['pot'];
        player.number = element.data()['shirt_number'];
        player.nation = element.data()['citizenship'];
        player.wage = element.data()['market_wert'];
        player.footPrefer = element.data()['foot_prefer'];
        player.birthday = element.data()['date_of_birth_age'];
        player.weight = element.data()['weight'];
        player.height = element.data()['height'];
        player.avatarUrl = gsUrl != null && gsUrl != ''
            ? await FirebaseStorage.instance.getReferenceFromUrl(gsUrl).then(
                (StorageReference ref) => ref
                    .getDownloadURL()
                    .then((dynamic snapshot) => snapshot.toString()))
            : '';
        player.ballSkill = _countStat(element.data()['ball_skills']);
        player.shooting = _countStat(element.data()['shooting']);
        player.defence = _countStat(element.data()['defence']);
        player.physical = _countStat(element.data()['physical']);
        player.passing = _countStat(element.data()['passing']);
        player.isExpand = false;
        player.offset = Offset.zero;
        players.add(player);
      }
    });
    return players;
  }

  String _countStat(Map<String, dynamic> map) {
    double stat = 0;
    if (map != null) {
      for (String str in map.values) {
        stat += double.parse(str);
      }
      stat /= map.values.length;
    }
    return stat.toString();
  }

  static Future<int> countLeagueFirebase() async {
    var i = await _firestoreInstance
        .collection('League')
        .orderBy('league_nation')
        .orderBy('league_name')
        .get()
        .then((value) => value.docs.length);
    return i;
  }
}
