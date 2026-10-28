import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/adding_bloc/adding_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/league/league.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/orientation/mutual_widgets/adding_image.dart';

class PortraitLeagues extends StatefulWidget {
  @override
  _PortraitLeaguesState createState() => _PortraitLeaguesState();
}

class _PortraitLeaguesState extends State<PortraitLeagues> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddingBloc, AddingState>(
      builder: (BuildContext context, AddingState state) {
        if (state is AddingLeagueSelecting) {
          return _buildLeagues(state.leagueByNation);
        }
        if (state is AddingClubsSelecting) {
          return _buildClubs(state.clubs, state.league);
        }
        if (state is AddingPlayersSelecting) {
          return _buildPlayers(club: state.club, players: state.players);
        }
        return BottomLoader();
      },
    );
  }

  Widget _buildPlayers({
    List<Player> players,
    Club club,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              context.bloc<AddingBloc>().add(ClubBack());
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 10, 7, 2),
              child: Row(
                children: <Widget>[
                  AddingImage(club.logoUrl),
                  SizedBox(width: 4),
                  Flexible(
                    fit: FlexFit.tight,
                    child: MyText(
                      text: club.name,
                      color: null,
                      fontSize: 19,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 1),
          ),
          Container(
            padding: EdgeInsets.only(left: 22),
            child: SingleChildScrollView(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return BlocBuilder<SelectedPlayerBloc,
                      SelectedPlayerEventPlayerState>(
                    builder: (BuildContext context,
                        SelectedPlayerEventPlayerState state) {
                      if (state is PlayersSelected) {
                        bool bSt = state.starting
                            .any((player) => player.id == players[index].id);
                        bool bSu = state.subs
                            .any((player) => player.id == players[index].id);
                        return InkWell(
                          onTap: () {
                            context
                                .bloc<SelectedPlayerBloc>()
                                .add(MultiPlayerSelect(players[index]));
                          },
                          child: Opacity(
                            opacity: state.isStarting
                                ? (bSu ? 0.3 : 1)
                                : (bSt ? 0.3 : 1),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(
                                children: <Widget>[
                                  AddingImage(players[index].avatarUrl,
                                      isPlayer: true),
                                  SizedBox(width: 4),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      players[index].name,
                                      style: TextStyle(
                                        color: null,
                                        fontSize: 19,
                                      ),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  bSt || bSu
                                      ? Icon(
                                          Icons.check,
                                          size: 22,
                                          color: Colors.orange,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return BottomLoader();
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubs(List<Club> clubs, League league) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              context.bloc<AddingBloc>().add(LeagueBack());
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 10, 7, 2),
              child: Row(
                children: <Widget>[
                  AddingImage(league.logoUrl),
                  SizedBox(width: 4),
                  Flexible(
                    fit: FlexFit.tight,
                    child: MyText(
                      text: league.name,
                      color: null,
                      fontSize: 19,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 1),
          ),
          Container(
            padding: EdgeInsets.only(left: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context.bloc<AddingBloc>().add(ClubSelect(clubs[index]));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        children: <Widget>[
                          AddingImage(clubs[index].logoUrl),
                          SizedBox(width: 4),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              clubs[index].name,
                              style: TextStyle(
                                color: null,
                                fontSize: 19,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeagues(Map<String, List<League>> leagueByNation) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: leagueByNation.length,
        itemBuilder: (context, i) {
          if (i < leagueByNation.length) {
            String nat = leagueByNation.keys.toList()[i];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6),
                  child: MyText(
                    text: '$nat',
                    color: Colors.black,
                    fontSize: 16,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: leagueByNation[nat].length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context
                                .bloc<AddingBloc>()
                                .add(LeagueSelect(leagueByNation[nat][index]));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                AddingImage(leagueByNation[nat][index].logoUrl),
                                SizedBox(width: 4),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: MyText(
                                    text: leagueByNation[nat][index].name,
                                    color: null,
                                    fontSize: 19,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(height: 0),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container(height: 50, child: BottomLoader());
          }
        },
      ),
    );
  }
}
