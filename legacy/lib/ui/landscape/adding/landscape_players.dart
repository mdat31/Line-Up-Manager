import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/adding_players_bloc/adding_player_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/orientation/mutual_widgets/adding_image.dart';
import 'package:marozi/ui/orientation/mutual_widgets/landscape_adding_divider.dart';

class LandscapePlayers extends StatefulWidget {
  @override
  _LandscapePlayersState createState() => _LandscapePlayersState();
}

class _LandscapePlayersState extends State<LandscapePlayers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.32,
      margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
      padding: EdgeInsets.only(left: 18, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: BlocBuilder<AddingPlayerBloc, AddingPlayerState>(
        builder: (BuildContext context, AddingPlayerState addingPlayerState) {
          if (addingPlayerState is PlayerFetchSuccess &&
              addingPlayerState.players != null) {
            return ListView.builder(
              itemCount: addingPlayerState.players.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    context.bloc<SelectedPlayerBloc>().add(
                        MultiPlayerSelect(addingPlayerState.players[index]));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      index != 0 && index < addingPlayerState.players.length
                          ? LandscapeAddingDivider()
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 6, right: 5),
                        child: BlocBuilder<SelectedPlayerBloc,
                            SelectedPlayerEventPlayerState>(
                          builder: (BuildContext context,
                              SelectedPlayerEventPlayerState playerState) {
                            if (playerState is PlayersSelected) {
                              bool bSt = playerState.starting.any((player) =>
                                  player.id ==
                                  addingPlayerState.players[index].id);
                              bool bSu = playerState.subs.any((player) =>
                                  player.id ==
                                  addingPlayerState.players[index].id);
                              return Opacity(
                                opacity: playerState.isStarting
                                    ? (bSu ? 0.3 : 1)
                                    : (bSt ? 0.3 : 1),
                                child: Row(
                                  children: <Widget>[
                                    AddingImage(
                                      addingPlayerState
                                          .players[index].avatarUrl,
                                      isPlayer: true,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: MyText(
                                        text: addingPlayerState
                                            .players[index].name,
                                        color: bSt || bSu
                                            ? Colors.deepOrangeAccent
                                            : Colors.black,
                                        fontSize: 15,
                                        textAlign: TextAlign.start,
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
                              );
                            }
                            return BottomLoader();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
