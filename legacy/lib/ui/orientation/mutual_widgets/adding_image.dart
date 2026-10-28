import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';

class AddingImage extends StatefulWidget {
  final String url;
  final bool isPlayer;

  AddingImage(this.url, {this.isPlayer = false});

  @override
  _AddingImageState createState() => _AddingImageState();
}

class _AddingImageState extends State<AddingImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.isPlayer ? 10000.0 : 0),
        child: CachedNetworkImage(
          alignment: Alignment.center,
          errorWidget: (context, string, dynamic) => Icon(
            Icons.error,
            color: Colors.orange,
          ),
          placeholder: (context, string) {
            return BottomLoader();
          },
          imageUrl: widget.url ?? '',
        ),
      ),
    );
  }
}
