import 'package:flutter/material.dart';

String tableFavorite = 'Favorite';
String tablePlayer = 'Players';
String playerId = 'id';
String playerName = 'name';
String playerAge = 'age';
String playerClubId = 'club_id';
String playerClubName = 'club_name';
String playerPosition = 'position';
String playerOverall = 'overall';
String playerPotential = 'potential';
String playerNumber = 'shirt_number';
String playerNation = 'nation';
String playerWage = 'wage';
String playerFootPrefer = 'foot_prefer';
String playerBirthday = 'birthday';
String playerWeight = 'weight';
String playerHeight = 'height';
String playerAvatarUrl = 'avatar_url';
String playerBallSkill = 'ball_skill';
String playerDefence = 'defence';
String playerShooting = 'shooting';
String playerPhysical = 'physical';
String playerAvatar = 'image_url';
String playerPassing = 'passing';
String playerIsExpand = 'isExpand';
String playerOffset = 'offset';

class Player {
  String id;
  String name;
  String age;
  String clubId;
  String clubName;
  String position;
  String overall;
  String potential;
  String number;
  String nation;
  String wage;
  String footPrefer;
  String birthday;
  String weight;
  String height;
  String avatarUrl;
  String ballSkill;
  String defence;
  String shooting;
  String physical;
  String passing;
  bool isExpand;
  Offset offset;

  Player({
    this.id,
    this.name,
    this.clubId,
    this.clubName,
    this.age,
    this.position,
    this.overall,
    this.potential,
    this.number,
    this.nation,
    this.wage,
    this.footPrefer,
    this.birthday,
    this.weight,
    this.height,
    this.avatarUrl,
    this.ballSkill,
    this.defence,
    this.shooting,
    this.physical,
    this.passing,
    this.isExpand,
    this.offset,
  });

  Player.fromMap(Map<String, dynamic> map) {
    id = map[playerId];
    name = map[playerName];
    age = map[playerAge];
    clubId = map[playerClubId];
    clubName = map[playerClubName];
    position = map[playerPosition];
    overall = map[playerOverall].toString();
    potential = map[playerPotential].toString();
    number = map[playerNumber];
    nation = map[playerNation];
    wage = map[playerWage];
    footPrefer = map[playerFootPrefer];
    birthday = map[playerBirthday];
    weight = map[playerWeight];
    height = map[playerHeight];
    avatarUrl = map[playerAvatarUrl];
    ballSkill = map[playerBallSkill];
    defence = map[playerDefence];
    shooting = map[playerShooting];
    physical = map[playerPhysical];
    passing = map[playerPassing];
    isExpand = map[playerIsExpand] == 0 ? false : true;
    offset = Offset.zero;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      playerId: id,
      playerName: name,
      playerAge: age,
      playerClubId: clubId,
      playerClubName: clubName,
      playerPosition: position,
      playerOverall: overall,
      playerPotential: potential,
      playerNumber: number,
      playerNation: nation,
      playerWage: wage,
      playerFootPrefer: footPrefer,
      playerBirthday: birthday,
      playerWeight: weight,
      playerHeight: height,
      playerAvatarUrl: avatarUrl,
      playerBallSkill: ballSkill,
      playerDefence: defence,
      playerShooting: shooting,
      playerPhysical: physical,
      playerPassing: passing,
      playerIsExpand: isExpand == true ? 0 : 1,
      playerOffset: offset.toString(),
    };
  }
}
