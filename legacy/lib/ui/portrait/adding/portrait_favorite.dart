import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/favorite_bloc/favorite_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/resources/custom_widgets/my_text.dart';

class PortraitFavorites extends StatefulWidget {
  @override
  _PortraitFavoritesState createState() => _PortraitFavoritesState();
}

class _PortraitFavoritesState extends State<PortraitFavorites> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (BuildContext context, FavoriteState favState) {
        if (favState is FavoriteLoadSuccess) {
          if (favState.list.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
                  child: MyText(
                    textAlign: TextAlign.start,
                    text: 'Favorite players',
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExpansionTile(
                    title: MyText(
                      textAlign: TextAlign.start,
                      text: '${favState.list.length} player(s)',
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    onExpansionChanged: (bool) {},
                    children: <Widget>[
                      Container(
                        height: favState.list.length < 5 ? null : 250,
                        padding: const EdgeInsets.only(left: 15.5, bottom: 13),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: favState.list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                context.bloc<SelectedPlayerBloc>().add(
                                    FavoriteSelect(favState.list[index].favId));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: BlocBuilder<SelectedPlayerBloc,
                                    SelectedPlayerEventPlayerState>(
                                  builder: (BuildContext context,
                                      SelectedPlayerEventPlayerState
                                          playerState) {
                                    if (playerState is PlayersSelected) {
                                      bool bSt = playerState.starting.any(
                                          (player) =>
                                              player.id ==
                                              favState.list[index].favId);
                                      bool bSu = playerState.subs.any(
                                          (player) =>
                                              player.id ==
                                              favState.list[index].favId);
                                      return Opacity(
                                        opacity: playerState.isStarting
                                            ? (bSu ? 0.3 : 1)
                                            : (bSt ? 0.3 : 1),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10000.0),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      BottomLoader(),
                                                  errorWidget: (context, string,
                                                      dynamic) {
                                                    return Icon(
                                                      Icons.error,
                                                      color: Colors.orange,
                                                    );
                                                  },
                                                  imageUrl: favState.list[index]
                                                          .favAvtUrl ??
                                                      '',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: MyText(
                                                  textAlign: TextAlign.start,
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  text: favState
                                                      .list[index].favName,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .bloc<SelectedPlayerBloc>()
                                                    .add(FavoriteSelect(favState
                                                        .list[index].favId));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0),
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
                                      );
                                    }
                                    return BottomLoader();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        } else {
          return Container(height: 60, child: BottomLoader());
        }
      },
    );
  }
}
