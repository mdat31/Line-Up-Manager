import 'package:marozi/model/player/player.dart';

class Favorite {
  String favId;
  String favName;
  String favAvtUrl;

  Favorite({
    this.favId,
    this.favName,
    this.favAvtUrl,
  });

  Favorite.fromMap(Map<String, dynamic> map) {
    favId = map[playerId];
    favName = map[playerName];
    favAvtUrl = map[playerAvatarUrl];
  }

  Map<String, dynamic> toMap() {
    var map = {
      playerId: favId,
      playerName: favName,
      playerAvatarUrl: favAvtUrl,
    };
    return map;
  }
}
