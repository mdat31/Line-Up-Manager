import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/bloc/adding/selected_players_bloc/selected_players_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/resources/colors.dart';
import 'package:marozi/resources/custom_widgets/auto_complete_tf.dart';
import 'package:marozi/resources/custom_widgets/bottom_loader.dart';
import 'package:marozi/ui/orientation/mutual_widgets/adding_image.dart';
import 'package:marozi/utils/load_image_service.dart';
import 'package:marozi/utils/search_service.dart';

class PortraitSearch extends StatefulWidget {
  @override
  _PortraitSearchState createState() => _PortraitSearchState();
}

class _PortraitSearchState extends State<PortraitSearch> {
  ScrollableAutoCompleteTextField searchTextField;

  GlobalKey<ScrollableAutoCompleteTextFieldState> acfKey =
      new GlobalKey(debugLabel: 'inputText');
  FocusNode _focusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  Future<QuerySnapshot> future;
  List<Player> players = [];

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _textController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  initiateSearch(String query) {
    setState(() {
      future = SearchService().searchByName(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          _textField(_textController, _focusNode),
          FutureBuilder(
            future: future,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return BottomLoader();
                  break;
                case ConnectionState.done:
                  players = [];
                  for (var element in snapshot.data.docs) {
                    var player = Player();
                    player.name = element.data()['player_name'];
                    player.id = element.id;
                    player.avatarUrl = element.data()['player_avatar_url'];
                    players.add(player);
                  }
                  snapshot.data.docs.forEach(
                    (element) async {},
                  );
                  return players.isEmpty
                      ? Container()
                      : _searchResult(snapshot.data.docs.length);
                  break;
                default:
                  return Container();
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _searchResult(int length) {
    return Container(
      height: length < 5 ? null : 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: players.length,
        padding: const EdgeInsets.only(bottom: 2),
        separatorBuilder: (context, index) => const Divider(
          height: 0.0,
          indent: 10,
          endIndent: 10,
        ),
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context
                    .bloc<SelectedPlayerBloc>()
                    .add(SearchSelect(players[index].id));
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 6),
                child: BlocBuilder<SelectedPlayerBloc,
                    SelectedPlayerEventPlayerState>(
                  builder: (BuildContext context,
                      SelectedPlayerEventPlayerState playerState) {
                    if (playerState is PlayersSelected) {
                      bool isSub = playerState.subs
                          .any((player) => player.id == players[index].id);
                      bool isSt = playerState.starting
                          .any((player) => player.id == players[index].id);
                      return Row(
                        children: [
                          FutureBuilder(
                            future: LoadImageService.loadImage(
                                context, players[index].avatarUrl),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return AddingImage(
                                snapshot.data,
                                isPlayer: true,
                              );
                            },
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              players[index].name,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          isSt || isSub
                              ? Icon(
                                  Icons.check,
                                  color: Colors.orange,
                                )
                              : Container(),
                        ],
                      );
                    }
                    return BottomLoader();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _textField(TextEditingController controller, FocusNode focusNode) {
    double customMinPrefixIconSize = 32;
    BoxConstraints iconConstraints = BoxConstraints(
      minWidth: customMinPrefixIconSize,
      minHeight: customMinPrefixIconSize,
    );
    return Container(
      decoration: BoxDecoration(
        color: colorScaffoldBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (query) {
          initiateSearch(query);
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Icon(
              Icons.search,
              size: 26,
              color: Colors.black38,
            ),
          ),
          suffixIcon: _textController.text.length != 0
              ? IconButton(
                  padding: EdgeInsets.all(0.0),
                  constraints: iconConstraints,
                  icon: Icon(Icons.clear, color: Colors.black12),
                  onPressed: () {
                    controller.clear();
                  },
                )
              : Icon(null),
          suffixIconConstraints: iconConstraints,
          prefixIconConstraints: iconConstraints,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
