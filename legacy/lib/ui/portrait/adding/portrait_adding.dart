import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/bloc/table/table_bloc/table_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/strings.dart';
import 'package:marozi/ui/portrait/adding/portrait_favorite.dart';
import 'package:marozi/ui/portrait/adding/portrait_leagues.dart';
import 'package:marozi/ui/portrait/adding/portrait_search.dart';

class PortraitAdding extends StatefulWidget {
  @override
  _PortraitAddingState createState() => _PortraitAddingState();
}

class _PortraitAddingState extends State<PortraitAdding> {
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
        listener: (BuildContext context, SelectedPlayerEventPlayerState state) {
          if (state is PlayersSelected) {
            if (state.isStarting && state.starting.length == 11) {
              _showSnackBar();
            } else {
              if (state.subs.length == 7) _showSnackBar();
            }
          }
        },
      ),
      body: SafeArea(
        top: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: <Widget>[
                _selectedImages(),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      PortraitSearch(),
                      PortraitFavorites(),
                      PortraitLeagues(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedImages() {
    return Container(
      height: 50,
      child: BlocBuilder<SelectedPlayerBloc, SelectedPlayerEventPlayerState>(
        builder: (BuildContext context, SelectedPlayerEventPlayerState state) {
          if (state is PlayersSelected) {
            bool isStarting = state.isStarting;
            List<Player> list = isStarting ? state.starting : state.subs;
            return ListView.builder(
              itemCount: isStarting ? 11 : 7,
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: index < list.length
                        ? CachedNetworkImage(
                            errorWidget: (context, str, dyna) => Icon(
                              Icons.error,
                              color: Colors.orange,
                            ),
                            placeholder: (context, string) => BottomLoader(),
                            imageUrl: list[index].avatarUrl ?? '',
                          )
                        : Image.asset('assets/images/no_face.jpg'),
                  ),
                );
              },
            );
          }
          return BottomLoader();
        },
      ),
    );
  }

  void _showSnackBar() {
    _scaffold.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Litmit Reached!'),
      ));
  }
}
