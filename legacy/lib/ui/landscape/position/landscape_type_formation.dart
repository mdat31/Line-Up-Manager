import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/position/position_bloc/position_bloc.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';

class LandscapeTypeFormation extends StatefulWidget {
  @override
  _LandscapeTypeFormationState createState() => _LandscapeTypeFormationState();
}

class _LandscapeTypeFormationState extends State<LandscapeTypeFormation> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PositionBloc, PositionState>(
        builder: (BuildContext context, PositionState state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              child: state is PositionSuccess
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: state.listFormations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  context
                                      .bloc<PositionBloc>()
                                      .add(FormationChange(index));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 55,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.listFormations[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: state.currentPage == index
                                          ? Colors.orange
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              index < state.offsets.length - 1
                                  ? Divider(height: 0)
                                  : Container(),
                            ],
                          ),
                        );
                      },
                    )
                  : BottomLoader(),
            ),
          );
        },
      ),
    );
  }
}
