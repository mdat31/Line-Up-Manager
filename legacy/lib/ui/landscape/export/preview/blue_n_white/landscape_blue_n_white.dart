import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/fonts.dart';

class LandscapeBlueAndWhite extends StatefulWidget {
  @override
  _LandscapeBlueAndWhiteState createState() => _LandscapeBlueAndWhiteState();
}

class _LandscapeBlueAndWhiteState extends State<LandscapeBlueAndWhite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.629,
      height: MediaQuery.of(context).size.height * 0.73,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/landscape_blue_n_white.png'),
        ),
      ),
      child: BlocBuilder<ExportBloc, ExportState>(
        builder: (BuildContext context, ExportState state) {
          if (state is ExportFromPositionSuccess) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.73,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        ...Iterable<int>.generate(state.players.length).map(
                          (index) => _player(
                            name: state.players[index].name,
                            number: state.players[index].number,
                            offset: state.offsets[index],
                            captain: state.captain,
                            showCaptain: state.showCaptain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _substitutes(),
              ],
            );
          }
          return BottomLoader();
        },
      ),
    );
  }

  Widget _substitutes() {
    return BlocBuilder<ExportBloc, ExportState>(
      builder: (BuildContext context, ExportState state) {
        if (state is ExportFromPositionSuccess) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'STARTING XI',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontFamily: fontBangersRegular,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        state.teamName.isEmpty
                            ? state.captain.clubName
                            : state.teamName,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontFamily: fontBangersRegular,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  state.showSubs
                      ? Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'SUBSTITUTES',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontFamily: fontBangersRegular,
                                ),
                              ),
                              ...Iterable.generate(7).map(
                                (i) => i < state.subsNames.length
                                    ? _subText(
                                        text: state.subsNames[i],
                                        fontSize: 15,
                                      )
                                    : SizedBox(
                                        height: 20,
                                      ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        }
        return BottomLoader();
      },
    );
  }

  Widget _subText({
    @required String text,
    @required double fontSize,
    Color color,
  }) {
    text = text.contains(' ')
        ? text.substring(text.indexOf(' ') + 1, text.length)
        : text;
    text = text.contains('-')
        ? text.substring(text.indexOf('-') + 1, text.length)
        : text;
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.red,
        fontFamily: fontBangersRegular,
      ),
    );
  }

  Widget _player({
    @required String name,
    @required String number,
    @required Offset offset,
    @required Player captain,
    @required bool showCaptain,
  }) {
    name = name.contains(' ')
        ? name.substring(name.indexOf(' ') + 1, name.length)
        : name;
    name = name.contains('-')
        ? name.substring(name.indexOf('-') + 1, name.length)
        : name;
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            number,
            style: TextStyle(
              fontSize: 30,
              fontFamily: fontBlackOpsOneRegular,
              color: Colors.blue,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: fontBangersRegular,
                  color: Colors.red,
                ),
              ),
              captain.name.contains(name) && showCaptain
                  ? Text(
                      ' C',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: fontBangersRegular,
                        color: Colors.blue,
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
