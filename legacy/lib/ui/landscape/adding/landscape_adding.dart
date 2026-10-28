import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/adding_bloc/adding_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/bloc/table/table_bloc/table_bloc.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/resources/strings.dart';
import 'package:marozi/ui/landscape/adding/landscape_clubs.dart';
import 'package:marozi/ui/landscape/adding/landscape_favorite.dart';
import 'package:marozi/ui/landscape/adding/landscape_leagues.dart';
import 'package:marozi/ui/landscape/adding/landscape_players.dart';
import 'package:marozi/ui/landscape/adding/landscape_search.dart';
import 'package:marozi/ui/orientation/mutual_widgets/landscape_adding_divider.dart';

class LandscapeAdding extends StatefulWidget {
  @override
  _LandscapeAddingState createState() => _LandscapeAddingState();
}

class _LandscapeAddingState extends State<LandscapeAdding> {
  GlobalKey<ScaffoldState> _scaffold;

  @override
  void initState() {
    _scaffold = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      floatingActionButton:
          BlocConsumer<SelectedPlayerBloc, SelectedPlayerEventPlayerState>(
        listener: (BuildContext context, SelectedPlayerEventPlayerState state) {
          if (state is PlayersSelected) {
            if (state.isStarting && state.starting.length == 11) {
              _showSnackBar();
            } else {
              if (state.subs.length == 7) _showSnackBar();
            }
          }
        },
        builder: (BuildContext context, SelectedPlayerEventPlayerState state) {
          if (state is PlayersSelected) {
            return WillPopScope(
              onWillPop: () async {
                // bool canGoBack =
                //     state.starting.length > 4 || state.subs.length > 2;
                // if (canGoBack) {
                //   context.bloc<TableBloc>().add(PlayerSelect(
                //         state.isStarting ? state.starting : state.subs,
                //         state.isStarting,
                //       ));
                // } else {
                //   _scaffold.currentState.showSnackBar(SnackBar(
                //     content: Text('Need at least 5 starting or 3 substitute'),
                //   ));
                // }
                // return canGoBack ? true : false;
                return true;
              },
              child: Visibility(
                visible: state.starting.length > 4 || state.subs.length > 2,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, table, ModalRoute.withName(homepage));
                    context.bloc<TableBloc>().add(PlayerSelect(
                          state.isStarting ? state.starting : state.subs,
                          state.isStarting,
                        ));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 25,
                  ),
                  backgroundColor: Colors.orange,
                ),
              ),
            );
          }
          return Container();
        },
      ),
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.289,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LandscapeSearch(),
                        LandscapeFavorite(),
                        _leaguesByNation(),
                      ],
                    ),
                  ),
                ),
                LandscapeClubs(),
                LandscapePlayers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _leaguesByNation() {
    return BlocBuilder<AddingBloc, AddingState>(
      builder: (BuildContext context, AddingState state) {
        if (state is AddingLeagueSelecting) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.leagueByNation.length,
            itemBuilder: (context, i) {
              String nat = state.leagueByNation.keys.toList()[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
                    child: MyText(
                      text: '$nat',
                      color: Colors.black,
                      fontSize: 15,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(13, 8, 8, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.leagueByNation[nat].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            index < state.leagueByNation[nat].length &&
                                    index != 0
                                ? LandscapeAddingDivider()
                                : Container(),
                            LandscapeLeagues(state.leagueByNation[nat][index]),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
        return BottomLoader();
      },
    );
  }

  void _showSnackBar() {
    _scaffold.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Limit Reached!'),
      ));
  }
}
