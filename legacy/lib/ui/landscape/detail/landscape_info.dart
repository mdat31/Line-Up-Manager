import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/detail/detail_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/ui/portrait/detail/custom_widget/text_cm.dart';
import 'package:marozi/ui/portrait/detail/custom_widget/text_fix.dart';
import 'package:marozi/ui/portrait/detail/custom_widget/text_info.dart';

class LandscapeInfo extends StatefulWidget {
  final Player player;
  final String clubUrl;
  final bool isFav;

  LandscapeInfo(this.player, this.clubUrl, this.isFav);

  @override
  _LandscapeInfoState createState() => _LandscapeInfoState();
}

class _LandscapeInfoState extends State<LandscapeInfo> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _infoTop(),
              Divider(
                indent: 25,
                endIndent: 25,
              ),
              _infoBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTop() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: CachedNetworkImage(
              placeholder: (context, string) => BottomLoader(),
              errorWidget: (context, string, dynamic) => Icon(
                Icons.error,
                color: Colors.orange,
              ),
              imageUrl: widget.player.avatarUrl ?? '',
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.width * 0.165,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: BlocBuilder<DetailBloc, DetailState>(
                    builder: (BuildContext context, DetailState state) {
                      if (state is DetailedLoadSuccess) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .bloc<DetailBloc>()
                                .add(UpdateFavorite(widget.player.id));
                          },
                          child: Icon(
                            Icons.favorite,
                            color: widget.isFav ? Colors.orange : Colors.grey,
                          ),
                        );
                      }
                      return BottomLoader();
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    TextFix('Height '),
                    TextInfo(widget.player.height),
                    TextSmallUpper('cm'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    TextFix('Weight '),
                    TextInfo(widget.player.weight),
                    TextSmallUpper('km'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    TextFix('Birth date '),
                    TextInfo(widget.player.birthday),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoBottom() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFix('Club'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.06,
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10000.0),
                          child: CachedNetworkImage(
                            placeholder: (context, string) => BottomLoader(),
                            errorWidget: (context, string, dynamic) => Icon(
                              Icons.error,
                              color: Colors.orange,
                            ),
                            imageUrl: widget.clubUrl ?? '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFix('Number'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.06,
                        alignment: Alignment.center,
                        child: TextInfo(widget.player.number),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFix('Value(€)'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.06,
                        alignment: Alignment.center,
                        child: TextInfo(
                          widget.player.wage.contains(' ')
                              ? widget.player.wage
                                  .substring(0, widget.player.wage.indexOf(' '))
                              : widget.player.wage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFix('Nation'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.06,
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10000.0),
                          child: CachedNetworkImage(
                            placeholder: (context, string) => BottomLoader(),
                            errorWidget: (context, string, dynamic) => Icon(
                              Icons.error,
                              color: Colors.orange,
                            ),
                            imageUrl: 'images/assets/england1.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFix('Number'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.06,
                        alignment: Alignment.center,
                        child: TextInfo(widget.player.number),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFix('Wage'),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.06,
                        alignment: Alignment.center,
                        child: TextInfo(
                          widget.player.wage.contains(' ')
                              ? widget.player.wage
                                  .substring(0, widget.player.wage.indexOf(' '))
                              : widget.player.wage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
