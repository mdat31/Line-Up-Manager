import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/fonts.dart';

class PreviewGloryBlue extends StatefulWidget {
  @override
  _PreviewGloryBlueState createState() => _PreviewGloryBlueState();
}

class _PreviewGloryBlueState extends State<PreviewGloryBlue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.629,
      height: MediaQuery.of(context).size.height * 0.73,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/landscape_blue.png'),
        ),
      ),
      child: BlocBuilder<ExportBloc, ExportState>(
        builder: (BuildContext context, ExportState state) {
          if (state is ExportFromPositionSuccess) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.52,
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.centerLeft,
                      children: [
                        Image.asset(
                          'assets/images/landscape_blue_field.png',
                        ),
                        ...Iterable<int>.generate(state.players.length).map(
                          (index) => _player(
                            name: state.players[index].name,
                            number: state.players[index].number,
                            avatarUrl: state.players[index].avatarUrl,
                            offset: state.offsets[index],
                            captain: state.captain,
                            showCaptain: state.showCaptain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _clubLogo(state.clubLogoUrl),
                _teamSubs(
                  subsName: state.subsNames,
                  coachName: state.coachName,
                  teamName: state.teamName,
                  clubName: state.captain.clubName,
                  showCoach: state.showCoach,
                  showSubs: state.showSubs,
                  showCaptain: state.showCaptain,
                ),
              ],
            );
          }
          return BottomLoader();
        },
      ),
    );
  }

  Widget _teamSubs({
    List<String> subsName,
    String coachName,
    String teamName,
    String clubName,
    bool showSubs,
    bool showCaptain,
    bool showCoach,
  }) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: _subsText(
                    name: teamName != null && teamName.isNotEmpty
                        ? teamName
                        : clubName,
                    fontSize: 17,
                  ),
                ),
                showCoach
                    ? Container(
                        alignment: Alignment.centerRight,
                        child: _subsText(
                          name: coachName != null && coachName.isNotEmpty
                              ? coachName
                              : 'Coach Name',
                          fontSize: 13,
                        ),
                      )
                    : SizedBox(height: 13),
                showSubs
                    ? Divider(
                        color: Colors.white,
                      )
                    : SizedBox(height: 13),
              ],
            ),
            Flexible(
              child: Visibility(
                visible: showSubs,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: _subsText(
                          name: 'Substitutes',
                          fontSize: 12,
                          color: colorSubstitutesLandscapeText,
                        ),
                      ),
                      ...Iterable<int>.generate(7).map(
                        (i) => i < subsName.length
                            ? _subsText(
                                name: subsName[i],
                                fontSize: 13,
                              )
                            : SizedBox(height: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clubLogo(String logoUrl) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.07,
      height: MediaQuery.of(context).size.width * 0.07,
      margin: EdgeInsets.only(left: 10, top: 10),
      child: CachedNetworkImage(
        placeholder: (context, string) => BottomLoader(),
        errorWidget: (context, string, dynamic) => Icon(
          Icons.error,
          color: Colors.grey,
        ),
        imageUrl: logoUrl ?? '',
      ),
    );
  }

  Widget _player({
    @required String name,
    @required String number,
    @required String avatarUrl,
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
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.width * 0.05,
            child: CachedNetworkImage(
              errorWidget: (context, string, dynamic) => Icon(
                Icons.error,
                color: Colors.grey,
              ),
              placeholder: (context, string) => BottomLoader(),
              imageUrl: avatarUrl ?? '',
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.085,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.065,
                    height: 12,
                    alignment: Alignment.center,
                    child: CustomPaint(
                      painter: PlayerNameTag(color: Colors.white),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width *
                                0.085 *
                                0.145,
                          ),
                          child: _playerNumber(number),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.065,
                  height: 12,
                  alignment: Alignment.center,
                  child: CustomPaint(
                    painter: PlayerNameTag(color: Colors.yellow),
                    child: _playersText(name, captain.name, showCaptain),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _playersText(String text, String captainName, bool showCaptain) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text.contains(' ')
                ? text.substring(text.lastIndexOf(' '), text.length)
                : text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorExportBlueText,
              fontSize: 10,
              fontFamily: fontTekoRegular,
            ),
          ),
        ),
        captainName.contains(text) && showCaptain
            ? Flexible(
                fit: FlexFit.loose,
                child: Text(
                  ' (c)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorExportBlueText,
                    fontSize: 10,
                    fontFamily: fontTekoRegular,
                  ),
                ),
              )
            : Container(
                width: 0,
                height: 0,
              ),
      ],
    );
  }

  Widget _playerNumber(String number) {
    return Text(
      number.contains(' ')
          ? number.substring(number.lastIndexOf(' '), number.length)
          : number,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: colorExportBlueText,
        fontSize: 10,
        fontFamily: fontTekoRegular,
      ),
    );
  }

  Widget _subsText({
    @required String name,
    Color color,
    @required double fontSize,
  }) {
    return Text(
      name,
      textAlign: TextAlign.end,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontFamily: fontTekoRegular,
      ),
    );
  }
}

class PlayerNameTag extends CustomPainter {
  final Color color;

  PlayerNameTag({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var points = List<Offset>();
    points.add(Offset(size.width * 0.2, 0));
    points.add(Offset(size.width, 0));
    points.add(Offset(size.width * 0.8, size.height));
    points.add(Offset(0, size.height));
    points.add(Offset(size.width * 0.2, 0));

    Path path = Path()..addPolygon(points, true);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

//    for (int i = 0; i < points.length - 1; i++) {
//      canvas.drawLine(points[i], points[i + 1], paint);
//    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
