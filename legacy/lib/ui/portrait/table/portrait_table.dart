import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/position/position_bloc/position_bloc.dart';
import 'package:marozi/bloc/table/table_bloc/table_bloc.dart';
import 'package:marozi/resources/fonts.dart';
import 'package:marozi/resources/strings.dart';
import 'package:marozi/ui/orientation/mutual_widgets/add_button.dart';
import 'package:marozi/ui/orientation/mutual_widgets/garbage_can.dart';
import 'package:marozi/ui/orientation/mutual_widgets/table_player_image.dart';

class PortraitTable extends StatefulWidget {
  @override
  _PortraitTableState createState() => _PortraitTableState();
}

class _PortraitTableState extends State<PortraitTable> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _topBar(),
              _starting(),
              _substitutes(),
              GarbageCan(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _starting() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.51,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Starting XI',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add(start: 0, isStartingSelect: true, count: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add(start: 4, isStartingSelect: true, count: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add(start: 8, isStartingSelect: true, count: 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _substitutes() {
    return Expanded(
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Substitutes',
                style: TextStyle(
                  fontFamily: fontSFDisplayRegular,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add(start: 0, isStartingSelect: false, count: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _add(start: 4, isStartingSelect: false, count: 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _add({int start, bool isStartingSelect, @required count}) {
    List<Widget> list = [];
    if (count == 3) {
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
    if (count == 3) {
      list.add(SizedBox(width: 1));
    }
    return list;
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(width: 20),
        Text(
          'Adding players',
          style: TextStyle(
            fontSize: 20,
          ),
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
                          CreateFormation(state.starting, state.subs, true));
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

  void _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Need at least 5 Starting and 3 Substitutes')));
  }
}
