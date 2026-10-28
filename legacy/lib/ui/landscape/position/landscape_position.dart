import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/bloc/position/position_bloc/position_bloc.dart';
import 'package:marozi/resources/strings.dart';
import 'package:marozi/ui/landscape/position/landscape_formation.dart';
import 'package:marozi/ui/landscape/position/landscape_type_formation.dart';

class LandscapePosition extends StatefulWidget {
  @override
  _LandscapePositionState createState() => _LandscapePositionState();
}

class _LandscapePositionState extends State<LandscapePosition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        left: true,
        right: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              _topBar(),
              Expanded(
                child: Row(
                  children: <Widget>[
                    LandscapeFormation(),
                    LandscapeTypeFormation(),
                  ],
                ),
              ),
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
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
        ),
        Text(
          'Position',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        BlocBuilder<PositionBloc, PositionState>(
          builder: (BuildContext context, PositionState state) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, export);
                  if (state is PositionSuccess) {
                    context.bloc<ExportBloc>().add(PositionToExport(
                        state.players, state.subs, state.offsets, false));
                  }
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.orange,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
