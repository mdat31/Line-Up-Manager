final String tableClubs = 'Clubs';
final String clubId = 'id';
final String clubLeagueId = 'league_id';
final String clubName = 'name';
final String clubLeagueName = 'league_name';
final String clubLogoUrl = 'logo_url';
final String clubIsExpand = 'is_expand';

class Club {
  String id;
  String name;
  String leagueId;
  String leagueName;
  String logoUrl;
  bool isExpand;

  Club({this.id, this.leagueId, this.leagueName, this.name, this.logoUrl});

  Club.fromMap(Map<String, dynamic> map) {
    id = map[clubId];
    leagueId = map[clubLeagueId];
    name = map[clubName];
    logoUrl = map[clubLogoUrl];
    leagueName = map[clubLeagueName];
    isExpand = map[clubIsExpand] == 0 ? false : true;
  }

  Map<String, dynamic> toMap() {
    var map = {
      clubId: id,
      clubLeagueId: leagueId,
      clubName: name,
      clubLogoUrl: logoUrl,
      clubLeagueName: leagueName,
      clubIsExpand: isExpand == false ? 0 : 1,
    };
    return map;
  }
}
