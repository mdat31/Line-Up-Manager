final String tableLeagues = 'Leagues';
final String leagueId = 'id';
final String leagueName = 'name';
final String leagueNation = 'nation';
final String leagueLogoUrl = 'logo_url';
final String leagueIsExpand = 'is_expand';
List<String> columnsName;

class League {
  String id;
  String name;
  String nation;
  String logoUrl;
  bool isExpand;

  League({this.id, this.name, this.nation, this.logoUrl, this.isExpand});

  League.fromMap(Map<String, dynamic> map) {
    id = map[leagueId];
    name = map[leagueName];
    nation = map[leagueNation];
    logoUrl = map[leagueLogoUrl];
    isExpand = map[leagueIsExpand] == 0 ? false : true;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      leagueId: id,
      leagueName: name,
      leagueNation: nation,
      leagueLogoUrl: logoUrl,
      leagueIsExpand: isExpand == false ? "0" : "1",
    };
    return map;
  }
}
