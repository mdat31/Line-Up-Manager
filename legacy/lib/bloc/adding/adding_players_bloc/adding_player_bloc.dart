import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/utils/firebase_to_local.dart';

part 'adding_player_event.dart';
part 'adding_player_state.dart';

class AddingPlayerBloc extends Bloc<AddingPlayerEvent, AddingPlayerState> {
  AddingPlayerBloc(AddingPlayerState initialState) : super(initialState);

  @override
  Stream<AddingPlayerState> mapEventToState(AddingPlayerEvent event) async* {
    if (event is GetPlayer) yield* _mapGetPlayerToState(event);

    if (event is ClearAddingPlayer) yield AddingPlayerInitial();
  }

  Stream<AddingPlayerState> _mapGetPlayerToState(GetPlayer event) async* {
    final getPlayers = FirebaseToLocal();
    List<Player> players = await getPlayers.getPlayersByClub(event.club);
    yield PlayerFetchSuccess(
      club: event.club,
      players: players,
    );
  }
}
