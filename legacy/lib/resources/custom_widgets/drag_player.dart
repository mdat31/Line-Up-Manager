import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/detail/detail_bloc.dart';
import 'package:marozi/bloc/position/position_bloc/position_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/fonts.dart';
import 'package:marozi/resources/strings.dart';

class DragPlayer extends StatefulWidget {
  final int index;

  DragPlayer(this.index);

  @override
  _DragPlayerState createState() => _DragPlayerState();
}

class _DragPlayerState extends State<DragPlayer> {
  Offset offset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _draggable();
  }

  Widget _draggable() {
    return BlocBuilder<PositionBloc, PositionState>(
      builder: (BuildContext context, state) {
        if (state is PositionSuccess) {
          offset = state.offsets[widget.index];
          return AnimatedPositioned(
            left: offset.dx,
            top: offset.dy,
            duration: Duration(milliseconds: 500),
            child: InkWell(
              onDoubleTap: () {
                context
                    .bloc<DetailBloc>()
                    .add(DetailFetch(state.players[widget.index].id));
                Navigator.pushNamed(context, detail,
                    arguments: state.players[widget.index].id);
              },
              child: Draggable(
                childWhenDragging: Container(),
                child: _dragChild(),
                feedback: _dragChild(),
                data: widget.index,
                onDraggableCanceled: (velocity, cancelOffset) {
                  double height;
                  double width;
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) {
                    height = MediaQuery.of(context).size.height * 0.83;
                    width = MediaQuery.of(context).size.width;
                  } else {
                    width = MediaQuery.of(context).size.width * 0.82;
                    height = MediaQuery.of(context).size.height;
                  }
                  context.bloc<PositionBloc>().add(
                      DropPlayer(cancelOffset, widget.index, width, height));
                },
                onDragEnd: (details) {},
              ),
            ),
          );
        } else {
          return BottomLoader();
        }
      },
    );
  }

  Widget _dragChild() {
    return DragTarget(
      builder: (BuildContext context, List<int> candidateData,
          List<dynamic> rejectedData) {
        return _player();
      },
      onWillAccept: (data) {
        return data != null ? true : false;
      },
      onAccept: (data) {
        context.bloc<PositionBloc>().add(PositionSwap(data, widget.index));
      },
    );
  }

  Widget _player() {
    return BlocBuilder<PositionBloc, PositionState>(
      builder: (BuildContext context, PositionState state) {
        if (state is PositionSuccess) {
          Player player = state.players[widget.index];
          return Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Container(
                  width: 65,
                  height: 65,
                  child: CachedNetworkImage(
                    errorWidget: (context, string, dynamic) {
                      return Icon(
                        Icons.error,
                        color: Colors.orange,
                      );
                    },
                    placeholder: (context, string) {
                      return BottomLoader();
                    },
                    imageUrl: state.players[widget.index].avatarUrl ?? '',
                  ),
                ),
              ),
              Text(
                player.name.indexOf(' ') > 0
                    ? player.name
                        .substring(player.name.indexOf(' '), player.name.length)
                    : player.name,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: fontSFDisplayRegular,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          );
        } else {
          return BottomLoader();
        }
      },
    );
  }
}
