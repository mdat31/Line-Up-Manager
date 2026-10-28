import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/fonts.dart';

class GloryRedPlayersPosition extends StatefulWidget {
  @override
  _GloryRedPlayersPositionState createState() =>
      _GloryRedPlayersPositionState();
}

class _GloryRedPlayersPositionState extends State<GloryRedPlayersPosition> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.986,
      height: MediaQuery.of(context).size.height * 0.521,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage('assets/images/mask_group.png'),
        ),
      ),
      child: BlocBuilder<ExportBloc, ExportState>(
        builder: (BuildContext context, ExportState state) {
          if (state is ExportFromPositionSuccess) {
            return Stack(
              overflow: Overflow.visible,
              children: [
                ...Iterable<int>.generate(state.players.length).map(
                  (index) => _player(
                    offset: state.offsets[index],
                    player: state.players[index],
                    captain: state.captain,
                    showCaptain: state.showCaptain,
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _player({
    @required Offset offset,
    @required Player player,
    @required Player captain,
    @required bool showCaptain,
  }) {
    String name = player.name;
    name = name.contains(' ')
        ? name.substring(name.indexOf(' ') + 1, name.length)
        : name;
    name = name.contains('-')
        ? name.substring(name.indexOf('-') + 1, name.length)
        : name;
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: MediaQuery.of(context).size.width * 0.18,
      height: MediaQuery.of(context).size.width * 0.17,
      child: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.13,
            height: MediaQuery.of(context).size.width * 0.13,
            child: Stack(
              overflow: Overflow.visible,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: CachedNetworkImage(
                    imageUrl: player.avatarUrl ?? '',
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, string, dynamic) {
                      return Icon(
                        Icons.error,
                        color: Colors.orange,
                      );
                    },
                    placeholder: (context, string) {
                      return BottomLoader();
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.045,
                    height: MediaQuery.of(context).size.width * 0.045,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10000.0),
                      color: Colors.yellow,
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        player.number,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorPlayerNumberExport,
                          fontFamily: fontBebasNeueBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    '$name',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: fontBebasNeueBold,
                    ),
                  ),
                ),
                player.id == captain.id && showCaptain
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          ' C',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontFamily: fontBebasNeueBold,
                          ),
                        ),
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
