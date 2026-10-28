import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/club/club_repository.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/model/player/player_repository.dart';
import 'package:marozi/utils/firestore_service.dart';

part 'selected_players_event.dart';
part 'selected_players_state.dart';

class SelectedPlayerBloc
    extends Bloc<SelectedPlayerEvent, SelectedPlayerEventPlayerState> {
  SelectedPlayerBloc(SelectedPlayerEventPlayerState initialState)
      : super(initialState);

  @override
  Stream<SelectedPlayerEventPlayerState> mapEventToState(
      SelectedPlayerEvent event) async* {
    if (event is TableUpdate) yield* _mapTableUpdateToState(event);

    if (event is MultiPlayerSelect) yield* _mapMultiPlayerSelectToState(event);

    if (event is SearchSelect) yield* _mapSearchSelectToState(event);

    if (event is FavoriteSelect) yield* _mapFavoriteSelectToState(event);
  }

  Stream<SelectedPlayerEventPlayerState> _mapTableUpdateToState(
      TableUpdate event) async* {
    yield PlayersSelected(
      isStarting: event.isStarting,
      starting: event.starting,
      subs: event.subs,
    );
  }

  Stream<SelectedPlayerEventPlayerState> _mapSearchSelectToState(
      SearchSelect event) async* {
    var currentState = state;
    var playerRepo = PlayerRepository();
    var clubRepo = ClubRepository();
    Player player;
    Club club;

    if (currentState is PlayersSelected) {
      if (currentState.isStarting) {
        List<Player> starting = List.from(currentState.starting);
        player = await FirestoreService().getPlayer(event.playerId);
        club = await FirestoreService().getClub(player.clubId);
        await playerRepo.insertPlayer(player);
        await clubRepo.insertClub(club);
        starting.any((player) => player.id == event.playerId)
            ? starting.removeWhere((player) => player.id == event.playerId)
            : starting.length < 11 ? starting.add(player) : print('');
        yield currentState.copyWith(starting: starting);
      } else {
        List<Player> subs = List.from(currentState.subs);
        player = await FirestoreService().getPlayer(event.playerId);
        club = await FirestoreService().getClub(player.clubId);
        await playerRepo.insertPlayer(player);
        await clubRepo.insertClub(club);
        subs.any((player) => player.id == event.playerId)
            ? subs.removeWhere((player) => player.id == event.playerId)
            : subs.length < 7 ? subs.add(player) : print('');
        yield currentState.copyWith(subs: subs);
      }
    }
  }

  Stream<SelectedPlayerEventPlayerState> _mapMultiPlayerSelectToState(
      MultiPlayerSelect event) async* {
    var currentState = state;
    if (currentState is PlayersSelected) {
      if (currentState.isStarting) {
        List<Player> starting = List.from(currentState.starting);
        starting.any((player) => player.id == event.player.id)
            ? starting.removeWhere((player) => player.id == event.player.id)
            : starting.length < 11 ? starting.add(event.player) : print('');
        yield currentState.copyWith(starting: starting);
      } else {
        List<Player> subs = List.from(currentState.subs);
        subs.any((player) => player.id == event.player.id)
            ? subs.removeWhere((player) => player.id == event.player.id)
            : subs.length < 7 ? subs.add(event.player) : print('');
        yield currentState.copyWith(subs: subs);
      }
    }
  }

  Stream<SelectedPlayerEventPlayerState> _mapFavoriteSelectToState(
      FavoriteSelect event) async* {
    var currentState = state;
    final playerRepo = PlayerRepository();
    if (currentState is PlayersSelected) {
      if (currentState.isStarting) {
        List<Player> starting = List.from(currentState.starting);
        Player player = await playerRepo.getPlayer(playerId: event.id);
        starting.any((player) => player.id == event.id)
            ? starting.removeWhere((player) => player.id == event.id)
            : starting.length < 11 ? starting.add(player) : print('');
        yield currentState.copyWith(starting: starting);
      } else {
        List<Player> subs = List.from(currentState.subs);
        Player player = await playerRepo.getPlayer(playerId: event.id);
        subs.any((player) => player.id == event.id)
            ? subs.removeWhere((player) => player.id == event.id)
            : subs.length < 7 ? subs.add(player) : print('');
        yield currentState.copyWith(subs: subs);
      }
    }
  }
}
