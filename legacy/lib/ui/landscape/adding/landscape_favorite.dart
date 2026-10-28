import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/favorite_bloc/favorite_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';

class LandscapeFavorite extends StatefulWidget {
  @override
  _LandscapeFavoriteState createState() => _LandscapeFavoriteState();
}

class _LandscapeFavoriteState extends State<LandscapeFavorite> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (BuildContext context, FavoriteState favState) {
        if (favState is FavoriteLoadSuccess) {
          return Container(
            margin: EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child:
                BlocBuilder<SelectedPlayerBloc, SelectedPlayerEventPlayerState>(
              builder: (BuildContext context,
                  SelectedPlayerEventPlayerState playerState) {
                if (playerState is PlayersSelected) {
                  return ExpansionTile(
                    title: MyText(
                      text: '${favState.list.length} players',
                      color: Colors.black,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                    initiallyExpanded: false,
                    children: <Widget>[
                      ListView.builder(
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: favState.list.length,
                        itemBuilder: (context, index) {
                          bool bSt = playerState.starting.any((player) =>
                              player.id == favState.list[index].favId);
                          bool bSu = playerState.subs.any((player) =>
                              player.id == favState.list[index].favId);
                          return Opacity(
                            opacity: playerState.isStarting
                                ? (bSu ? 0.3 : 1)
                                : (bSt ? 0.3 : 1),
                            child: InkWell(
                              onTap: () {
                                context.bloc<SelectedPlayerBloc>().add(
                                    FavoriteSelect(favState.list[index].favId));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 47,
                                      height: 47,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10000.0),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              BottomLoader(),
                                          errorWidget:
                                              (context, string, dynamic) {
                                            return Icon(
                                              Icons.error,
                                              color: Colors.orange,
                                            );
                                          },
                                          imageUrl:
                                              favState.list[index].favAvtUrl ??
                                                  '',
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: MyText(
                                          textAlign: TextAlign.start,
                                          color: Colors.black,
                                          fontSize: 17,
                                          text: favState.list[index].favName,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.bloc<SelectedPlayerBloc>().add(
                                            FavoriteSelect(
                                                favState.list[index].favId));
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: bSt || bSu
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.orange,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
                return BottomLoader();
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
