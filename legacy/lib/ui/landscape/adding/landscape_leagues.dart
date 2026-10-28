import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/adding_players_bloc/adding_player_bloc.dart';
import 'package:marozi/bloc/adding/club_bloc/club_bloc.dart';
import 'package:marozi/model/league/league.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/orientation/mutual_widgets/adding_image.dart';

class LandscapeLeagues extends StatefulWidget {
  final League league;

  LandscapeLeagues(this.league);

  @override
  _LandscapeLeaguesState createState() => _LandscapeLeaguesState();
}

class _LandscapeLeaguesState extends State<LandscapeLeagues> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.bloc<AddingPlayerBloc>().add(ClearAddingPlayer());
        context.bloc<ClubBloc>().add(GetClub(widget.league));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: AddingImage(widget.league.logoUrl),
          ),
          BlocBuilder<ClubBloc, ClubState>(
            builder: (BuildContext context, ClubState clubState) {
              return Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: MyText(
                    text: widget.league.name,
                    color: clubState is ClubFetchSuccess &&
                            clubState.league != null &&
                            clubState.league.id == widget.league.id
                        ? Colors.deepOrangeAccent
                        : Colors.black,
                    fontSize: 16,
                    textAlign: TextAlign.start,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
