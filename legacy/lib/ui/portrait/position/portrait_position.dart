import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/export/export_bloc.dart';
import 'package:marozi/bloc/position/position_bloc/position_bloc.dart';
import 'package:marozi/resources/strings.dart';
import 'package:marozi/ui/portrait/position/portrait_formation.dart';
import 'package:marozi/ui/portrait/position/portrait_type_formation.dart';

class PortraitPosition extends StatefulWidget {
  @override
  _PortraitPositionState createState() => _PortraitPositionState();
}

class _PortraitPositionState extends State<PortraitPosition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        child: Container(
          padding: EdgeInsets.only(bottom: 0),
          child: Column(
            children: <Widget>[
              _topBar(),
              PortraitFormation(),
              _textFormation(),
              PortraitTypeFormation(),
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
          onTap: () => Navigator.of(context).pop(),
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
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, export);
                if (state is PositionSuccess) {
                  context.bloc<ExportBloc>().add(PositionToExport(
                      state.players, state.subs, state.offsets, true));
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

  Widget _textFormation() {
    return Text(
      'Formation',
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }
}
