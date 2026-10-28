import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/player/player.dart';

class FirestoreService {
  static FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  Future<Player> getPlayer(String playerId) async {
    Player player = Player();
    await _firestoreInstance
        .collection('Player')
        .doc(playerId)
        .get()
        .then((element) async {
      var gsUrl = element.data()['player_avatar_url'];
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
    });
    return player;
  }

  Future<Club> getClub(String clubId) async {
    Club club = Club();
    await _firestoreInstance
        .collection('Club')
        .doc(clubId)
        .get()
        .then((element) async {
      var gsUrl = element.data()['club_logo_url'];
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
    });
    return club;
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
}
