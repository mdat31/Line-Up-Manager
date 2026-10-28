import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/club/club_repository.dart';
import 'package:marozi/model/favorite/favorite_repository.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/model/player/player_repository.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(DetailState initialState) : super(initialState);

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is DetailFetch) yield* _mapDetailFetchToState(event);

    if (event is UpdateFavorite) yield* _mapUpdateFavoriteToState(event);
  }

  Stream<DetailState> _mapDetailFetchToState(DetailFetch event) async* {
    final playerRepo = PlayerRepository();
    final clubRepo = ClubRepository();
    final favRepo = FavoriteRepository();
    final player = await playerRepo.getPlayer(playerId: event.playerId);

    yield DetailedLoadSuccess(
      player: player,
      clubUrl: await clubRepo.getAColOfClub(
        clubId: player.clubId,
        columns: [clubLogoUrl],
      ),
      isFav: await favRepo.isFavorite(playerId: player.id),
    );
  }

  Stream<DetailState> _mapUpdateFavoriteToState(UpdateFavorite event) async* {
    var currentState = state;
    final favRepo = FavoriteRepository();
    if (currentState is DetailedLoadSuccess) {
      if (currentState.isFav) {
        await favRepo.deleteFavorite(playerId: event.playerId);
        yield currentState.copyWith(isFav: !currentState.isFav);
      } else {
        await favRepo.insertFavorite(playerId: event.playerId);
        yield currentState.copyWith(isFav: !currentState.isFav);
      }
    }
  }
}
