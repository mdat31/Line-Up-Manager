import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/adding_bloc/adding_bloc.dart';
import 'package:marozi/bloc/adding/favorite_bloc/favorite_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/strings.dart';

class AddButton extends StatefulWidget {
  final List<Player> starting;
  final List<Player> subs;
  final bool isStartingSelect;

  AddButton({
    @required this.starting,
    @required this.isStartingSelect,
    @required this.subs,
  });

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        child: InkWell(
          splashColor: Colors.orangeAccent, // inkwell color
          child: Container(
            width: 65,
            height: 65,
            color: colorScaffoldBackground,
            child: Icon(
              Icons.add_circle,
              color: Colors.orange,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(adding);
            context.bloc<SelectedPlayerBloc>().add(TableUpdate(
                  starting: widget.starting,
                  isStarting: widget.isStartingSelect,
                  subs: widget.subs,
                ));
            context.bloc<AddingBloc>().add(GetLeagueByNation());
            context.bloc<FavoriteBloc>().add(FavoriteFetch());
          },
        ),
      ),
    );
  }
}
