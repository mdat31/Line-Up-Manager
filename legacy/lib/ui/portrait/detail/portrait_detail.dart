import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/detail/detail_bloc.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';
import 'package:marozi/ui/portrait/detail/portrait_info.dart';
import 'package:marozi/ui/portrait/detail/portrait_stat.dart';

class PortraitPlayerDetail extends StatefulWidget {
  @override
  _PortraitPlayerDetailState createState() => _PortraitPlayerDetailState();
}

class _PortraitPlayerDetailState extends State<PortraitPlayerDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: true,
        child: BlocBuilder<DetailBloc, DetailState>(
          builder: (BuildContext context, DetailState state) {
            if (state is DetailedLoadSuccess) {
              return Column(
                children: <Widget>[
                  _topBar(state.player.name),
                  PortraitInfo(state.player, state.clubUrl, state.isFav),
                  PortraitStat(state.player),
                ],
              );
            }
            return BottomLoader();
          },
        ),
      ),
    );
  }

  Widget _topBar(String playerName) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          SizedBox(width: 8),
          MyText(
            text: playerName,
            color: Colors.black,
            fontSize: 20,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
