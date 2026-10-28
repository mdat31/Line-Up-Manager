import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/resources/fonts.dart';
import 'package:marozi/ui/portrait/export/preview/glory_red/glory_red_players_position.dart';

class PreviewGloryRed extends StatefulWidget {
  @override
  _PreviewGloryRedState createState() => _PreviewGloryRedState();
}

class _PreviewGloryRedState extends State<PreviewGloryRed> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExportBloc, ExportState>(
      builder: (BuildContext context, ExportState state) {
        if (state is ExportFromPositionSuccess) {
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/portrait_red.png',
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _clubCoach(state),
                  GloryRedPlayersPosition(),
                  _substitutes(),
                ],
              ),
            ],
          );
        }
        return BottomLoader();
      },
    );
  }

  Widget _clubCoach(ExportFromPositionSuccess state) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.13,
            height: MediaQuery.of(context).size.width * 0.13,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CachedNetworkImage(
              errorWidget: (context, string, dynamic) {
                return Icon(
                  Icons.error,
                  color: Colors.grey,
                );
              },
              placeholder: (context, string) {
                return BottomLoader();
              },
              imageUrl: state.clubLogoUrl ?? '',
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  state.teamName != null
                      ? state.teamName.isNotEmpty
                          ? state.teamName
                          : state.captain.clubName
                      : state.teamName,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.81,
                    fontFamily: fontBebasNeueBold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  state.coachName != null
                      ? state.coachName.isNotEmpty
                          ? state.coachName.toUpperCase()
                          : ''
                      : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.09,
                    fontFamily: fontBebasNeueRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _substitutes() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      child: BlocBuilder<ExportBloc, ExportState>(
        builder: (BuildContext context, ExportState state) {
          if (state is ExportFromPositionSuccess) {
            return state.showSubs
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: MyText(
                            color: colorSubstitutesText,
                            fontSize: 12,
                            fontFamily: fontBebasNeueRegular,
                            text: 'SUBSTITUTES'.toUpperCase(),
                            isTitleCase: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ...Iterable<int>.generate(
                                          state.subsNames.length)
                                      .map(
                                    (i) => _subsName(state.subsNames[i]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          }
          return BottomLoader();
        },
      ),
    );
  }

  Widget _subsName(String text) {
    text = text.contains(' ')
        ? text.substring(text.indexOf(' ') + 1, text.length)
        : text;
    text = text.contains('-')
        ? text.substring(text.indexOf('-') + 1, text.length)
        : text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MyText(
        color: Colors.white,
        fontSize: 15,
        fontFamily: fontBebasNeueRegular,
        text: text.toUpperCase(),
        isTitleCase: false,
      ),
    );
  }
}
