import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/adding_players_bloc/adding_player_bloc.dart';
import 'package:marozi/bloc/adding/club_bloc/club_bloc.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/orientation/mutual_widgets/adding_image.dart';
import 'package:marozi/ui/orientation/mutual_widgets/landscape_adding_divider.dart';

class LandscapeClubs extends StatefulWidget {
  @override
  _LandscapeClubsState createState() => _LandscapeClubsState();
}

class _LandscapeClubsState extends State<LandscapeClubs> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: double.infinity,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: EdgeInsets.only(left: 18, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: BlocBuilder<ClubBloc, ClubState>(
          builder: (BuildContext context, ClubState clubState) {
            if (clubState is ClubFetchSuccess && clubState.clubs != null) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: clubState.clubs.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      context
                          .bloc<AddingPlayerBloc>()
                          .add(GetPlayer(clubState.clubs[index]));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        index != 0 && index < clubState.clubs.length
                            ? LandscapeAddingDivider()
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 6.5),
                          child: Row(
                            children: <Widget>[
                              AddingImage(clubState.clubs[index].logoUrl),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 6),
                                  child: BlocBuilder<AddingPlayerBloc,
                                      AddingPlayerState>(
                                    builder: (BuildContext context,
                                        AddingPlayerState addingPlayerState) {
                                      return MyText(
                                        text: clubState.clubs[index].name,
                                        color: addingPlayerState
                                                    is PlayerFetchSuccess &&
                                                addingPlayerState.club !=
                                                    null &&
                                                addingPlayerState.club.id ==
                                                    clubState.clubs[index].id
                                            ? Colors.deepOrangeAccent
                                            : Colors.black,
                                        fontSize: 15,
                                        textAlign: TextAlign.start,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
