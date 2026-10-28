import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/data/constants.dart';
import 'package:marozi/data/position/landscape_offset_user.dart';
import 'package:marozi/data/position/portrait_offset_user.dart';
import 'package:marozi/model/favorite/favorite.dart';
import 'package:marozi/model/favorite/favorite_repository.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/model/player/player_repository.dart';

part 'position_event.dart';
part 'position_state.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc(PositionState initialState) : super(initialState);

  @override
  Stream<PositionState> mapEventToState(PositionEvent event) async* {
    if (event is CreateFormation) yield* _mapCreateFormationToState(event);

    if (event is PositionTestEvent) yield* _mapTestEventToState(event);

    if (event is FormationChange) yield* _mapFormationChangeToState(event);

    if (event is PositionSwap) yield* _mapPositionSwapToState(event);

    if (event is DropPlayer) yield* _mapDropPlayerToState(event);
  }

  Stream<PositionState> _mapTestEventToState(PositionTestEvent event) async* {
    yield PositionSuccess(
      players: await _getListFav(),
      isPortrait: event.isPortrait,
      offsets: event.isPortrait
          ? PortraitOffsetUser.offset_4_2_3_1
          : LandscapeOffsetUser.offset_4_2_3_1,
      listFormations: Constants.formations,
      currentPage: 0,
    );
  }

  Stream<PositionState> _mapCreateFormationToState(
      CreateFormation event) async* {
    yield PositionSuccess(
      listFormations: Constants.formations,
      currentPage: 0,
      players: event.starting,
      subs: event.subs,
      isPortrait: event.isPortrait,
      offsets: event.isPortrait
          ? PortraitOffsetUser.offset_4_2_3_1
          : LandscapeOffsetUser.offset_4_2_3_1,
    );
  }

  Stream<PositionState> _mapPositionSwapToState(PositionSwap event) async* {
    var currentState = state;
    if (currentState is PositionSuccess) {
      List<Offset> offsets = List.from(currentState.offsets);

      Offset temp = offsets[event.first];
      offsets[event.first] = offsets[event.second];
      offsets[event.second] = temp;

      yield currentState.copyWith(offsets: offsets);

      _updateOffset(
        currentState.listFormations[currentState.currentPage],
        offsets,
        currentState.isPortrait,
      );
    }
  }

  Stream<PositionState> _mapDropPlayerToState(DropPlayer event) async* {
    var currentState = state;
    if (currentState is PositionSuccess) {
      List<Offset> offsets = List.from(currentState.offsets);
      double top = event.offset.dy;
      double left = event.offset.dx;

      if ((left) > (event.width - 73.0)) {
        left = event.width - 73.0;
      } else if ((left) < 0.0) {
        left = 0.0;
      } else {
        left = event.offset.dx - 4.0;
      }

      if ((top - 51.5) > (event.height - 90)) {
        top = event.height - 90;
      } else if ((top - 51.5) < 0.0) {
        top = 0.0;
      } else {
        top = event.offset.dy - 51.5;
      }

      offsets[event.index] = Offset(left, top);

      yield currentState.copyWith(offsets: offsets);
      _updateOffset(
        currentState.listFormations[currentState.currentPage],
        offsets,
        currentState.isPortrait,
      );
    }
  }

  Stream<PositionState> _mapFormationChangeToState(
      FormationChange event) async* {
    var currentState = state;
    if (currentState is PositionSuccess) {
      switch (event.i) {
        case 0:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_2_3_1
                : LandscapeOffsetUser.offset_4_2_3_1,
          );
          break;
        case 1:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_3_3
                : LandscapeOffsetUser.offset_4_3_3,
          );
          break;
        case 2:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 3:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 4:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 5:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 6:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 7:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 8:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 9:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 10:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        case 11:
          yield currentState.copyWith(
            currentPage: event.i,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
        default:
          yield currentState.copyWith(
            currentPage: 0,
            offsets: currentState.isPortrait
                ? PortraitOffsetUser.offset_4_4_2
                : LandscapeOffsetUser.offset_4_4_2,
          );
          break;
      }
    }
  }

  void _updateOffset(String formation, List<Offset> offsets, bool isPortrait) {
    switch (formation) {
      case '4-2-3-1':
        isPortrait
            ? PortraitOffsetUser.offset_4_2_3_1 = offsets
            : LandscapeOffsetUser.offset_4_2_3_1 = offsets;
        break;
      case '4-3-3':
        isPortrait
            ? PortraitOffsetUser.offset_4_3_3 = offsets
            : LandscapeOffsetUser.offset_4_3_3 = offsets;
        break;
      case '4-4-2':
        isPortrait
            ? PortraitOffsetUser.offset_4_4_2 = offsets
            : LandscapeOffsetUser.offset_4_4_2 = offsets;
        break;
    }
  }

  Future<List<Player>> _getListFav() async {
    final favRepo = FavoriteRepository();
    final playerRepo = PlayerRepository();
    List<Favorite> listFav = await favRepo.getAllFavorite();
    List<Player> players = [];
    for (var fav in listFav) {
      Player player = await playerRepo.getPlayer(playerId: fav.favId);
      players.add(player);
    }
    return players;
  }
}
