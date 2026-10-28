import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/position/position_bloc/position_bloc.dart';
import 'package:marozi/bloc/table/table_bloc/table_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/resources/strings.dart';
import 'package:marozi/ui/orientation/mutual_widgets/add_button.dart';
import 'package:marozi/ui/orientation/mutual_widgets/garbage_can.dart';
import 'package:marozi/ui/orientation/mutual_widgets/table_player_image.dart';

class LandscapeTable extends StatefulWidget {
  @override
  _LandscapeTableState createState() => _LandscapeTableState();
}

class _LandscapeTableState extends State<LandscapeTable> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: true,
          left: true,
          right: true,
          child: Column(
            children: [
              _topBar(),
              _center(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(),
        MyText(
          text: 'Adding Players',
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.w500,
        ),
        BlocBuilder<TableBloc, TableState>(
          builder: (BuildContext context, TableState state) {
            return InkWell(
              onTap: () {
                if (state is TableAddedSuccess) {
                  if (state.starting != null && state.subs != null) {
                    if (state.starting.length > 4 && state.subs.length > 2) {
                      Navigator.pushNamed(context, position);
                      context.bloc<PositionBloc>().add(
                          CreateFormation(state.starting, state.subs, false));
                    } else {
                      _showSnackBar();
                    }
                  } else {
                    _showSnackBar();
                  }
                } else {
                  _showSnackBar();
                }
              },
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.orange,
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _add({int start, bool isStartingSelect, @required count}) {
    List<Widget> list = [];
    if (count == 2) {
      list.add(SizedBox(width: 1));
    }

    for (int i = start; i < start + count; i++) {
      list.add(
        BlocBuilder<TableBloc, TableState>(
          builder: (BuildContext context, TableState state) {
            if (state is TableAddedSuccess) {
              if (isStartingSelect) {
                if (state.starting != null && i < state.starting.length) {
                  return TablePlayerImage(
                    state.starting[i],
                    index: i,
                    isStarting: isStartingSelect,
                  );
                } else {
                  return AddButton(
                    isStartingSelect: isStartingSelect,
                    starting: state.starting ?? [],
                    subs: state.subs ?? [],
                  );
                }
              } else {
                if (state.subs != null && i < state.subs.length) {
                  return TablePlayerImage(
                    state.subs[i],
                    index: i,
                    isStarting: isStartingSelect,
                  );
                } else {
                  return AddButton(
                    isStartingSelect: isStartingSelect,
                    starting: state.starting ?? [],
                    subs: state.subs ?? [],
                  );
                }
              }
            }
            return AddButton(
              isStartingSelect: isStartingSelect,
              starting: [],
              subs: [],
            );
          },
        ),
      );
    }
    if (count == 2) {
      list.add(SizedBox(width: 1));
    }
    return list;
  }

  Widget _center() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GarbageCan(),
          _starting(),
          _substitute(),
        ],
      ),
    );
  }

  Widget _starting() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.51,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          MyText(text: 'Starting XI', color: Colors.black, fontSize: 18),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _add(start: 0, isStartingSelect: true, count: 3),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _add(start: 3, isStartingSelect: true, count: 3),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _add(start: 6, isStartingSelect: true, count: 3),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _add(start: 9, isStartingSelect: true, count: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _substitute() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            MyText(text: 'Substitutes', color: Colors.black, fontSize: 18),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add(start: 0, isStartingSelect: false, count: 3),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add(start: 3, isStartingSelect: false, count: 3),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add1(start: 6, isStartingSelect: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _add1({int start, List<Player> players, bool isStartingSelect}) {
    List<Widget> list = [];
    if (players != null && players.contains(start)) {
      list.add(_player(players[start], start));
    } else {
      list.add(BlocBuilder<TableBloc, TableState>(
        builder: (BuildContext context, TableState state) {
          if (state is TableAddedSuccess) {
            if (isStartingSelect) {
              if (state.starting != null && 6 < state.starting.length) {
                return TablePlayerImage(
                  state.starting[6],
                  index: 6,
                  isStarting: isStartingSelect,
                );
              } else {
                return AddButton(
                  isStartingSelect: isStartingSelect,
                  starting: state.starting ?? [],
                  subs: state.subs ?? [],
                );
              }
            } else {
              if (state.subs != null && 6 < state.subs.length) {
                return TablePlayerImage(
                  state.subs[6],
                  index: 6,
                  isStarting: isStartingSelect,
                );
              } else {
                return AddButton(
                  isStartingSelect: isStartingSelect,
                  starting: state.starting ?? [],
                  subs: state.subs ?? [],
                );
              }
            }
          }
          return AddButton(
            isStartingSelect: isStartingSelect,
            starting: [],
            subs: [],
          );
        },
      ));
    }
    return list;
  }

  Widget _player(Player player, int key) {
    return Draggable(
      data: key,
      feedback: TablePlayerImage(player),
      child: TablePlayerImage(player),
    );
  }

  void _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Need at least 5 Starting and 3 Substitutes'),
    ));
  }
}
