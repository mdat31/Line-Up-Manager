import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/auto_complete_tf.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/utils/search_service.dart';

class LandscapeSearch extends StatefulWidget {
  @override
  _LandscapeSearchState createState() => _LandscapeSearchState();
}

class _LandscapeSearchState extends State<LandscapeSearch> {
  FocusNode _focusNode;
  ScrollableAutoCompleteTextField searchTf;
  TextEditingController _textController;
  GlobalKey<ScrollableAutoCompleteTextFieldState> key;
  Future<QuerySnapshot> future;
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    key = GlobalKey<ScrollableAutoCompleteTextFieldState>();
    _focusNode = FocusNode();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _textController.dispose();
  }

  initiateSearch(String query) {
    setState(() {
      future = SearchService().searchByName(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    double customIconSize = 32;
    BoxConstraints iconConstraints = BoxConstraints(
      minHeight: customIconSize,
      minWidth: customIconSize,
    );
    return Container(
      width: MediaQuery.of(context).size.width * 0.33,
      // height: 55,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(17, 10, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorScaffoldBackground,
            ),
            margin: EdgeInsets.only(bottom: 10),
            child: TextField(
              key: key,
              focusNode: _focusNode,
              controller: _textController,
              onChanged: (String query) {
                initiateSearch(query);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                isDense: true,
                prefixIcon: Icon(
                  Icons.search,
                  size: 23,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                prefixIconConstraints: iconConstraints,
              ),
            ),
          ),
          FutureBuilder(
            future: future,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return BottomLoader();
                  break;
                case ConnectionState.done:
                  players = [];
                  snapshot.data.docs.forEach((element) async {
                    var player = Player();
                    player.name = element.data()['player_name'];
                    player.id = element.id;
                    players.add(player);
                  });
                  return players.isEmpty
                      ? Container()
                      : Container(
                          height: snapshot.data.docs.length < 5 ? null : 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )),
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: players.length,
                            padding: const EdgeInsets.only(bottom: 2),
                            separatorBuilder: (context, index) => const Divider(
                              height: 0.8,
                              indent: 10,
                              endIndent: 10,
                            ),
                            itemBuilder: (context, index) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .bloc<SelectedPlayerBloc>()
                                        .add(SearchSelect(players[index].id));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 14, 5, 8),
                                    child: BlocBuilder<SelectedPlayerBloc,
                                        SelectedPlayerEventPlayerState>(
                                      builder: (BuildContext context,
                                          SelectedPlayerEventPlayerState
                                              playerState) {
                                        if (playerState is PlayersSelected) {
                                          bool isSub = playerState.subs.any(
                                              (player) =>
                                                  player.id ==
                                                  players[index].id);
                                          bool isSt = playerState.starting.any(
                                              (player) =>
                                                  player.id ==
                                                  players[index].id);
                                          return Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  players[index].name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              isSub || isSt
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.orange,
                                                    )
                                                  : Container(),
                                            ],
                                          );
                                        }
                                        return BottomLoader();
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                  break;
                default:
                  return Container();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
