import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/detail/detail_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/landscape/detail/landscape_info.dart';
import 'package:marozi/ui/landscape/detail/landscape_stat.dart';

class LandscapePlayerDetail extends StatefulWidget {
  @override
  _LandscapePlayerDetailState createState() => _LandscapePlayerDetailState();
}

class _LandscapePlayerDetailState extends State<LandscapePlayerDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BlocBuilder<DetailBloc, DetailState>(
            builder: (BuildContext context, DetailState state) {
              if (state is DetailedLoadSuccess) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          _topBar(state.player),
                          LandscapeInfo(
                              state.player, state.clubUrl, state.isFav),
                        ],
                      ),
                    ),
                    LandscapeStat(state.player),
                  ],
                );
              }
              return BottomLoader();
            },
          ),
        ),
      ),
    );
  }

  Widget _topBar(Player player) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          MyText(
            text: player.name,
            isTitleCase: false,
            color: Colors.black,
            fontSize: 19,
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
