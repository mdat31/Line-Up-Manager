import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/detail/detail_bloc.dart';
import 'package:marozi/model/player/player.dart';

class TablePlayerImage extends StatefulWidget {
  final Player player;
  final int index;
  final bool isStarting;

  TablePlayerImage(this.player, {this.index, this.isStarting});

  @override
  _TablePlayerImageState createState() => _TablePlayerImageState();
}

class _TablePlayerImageState extends State<TablePlayerImage> {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: [widget.index, widget.isStarting],
      feedback: _image(),
      child: _image(),
    );
  }

  Widget _image() {
    return Container(
      width: 65,
      height: 65,
      child: GestureDetector(
        onTap: () {
          context.bloc<DetailBloc>().add(DetailFetch(widget.player.id));
          Navigator.pushNamed(context, '/detail', arguments: widget.player.id);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10000.0),
          child: CachedNetworkImage(
            errorWidget: (context, string, dynamic) {
              return Icon(
                Icons.error,
                color: Colors.orange,
              );
            },
            placeholder: (context, string) {
              return CircularProgressIndicator();
            },
            imageUrl: widget.player.avatarUrl ?? '',
          ),
        ),
      ),
    );
  }
}
