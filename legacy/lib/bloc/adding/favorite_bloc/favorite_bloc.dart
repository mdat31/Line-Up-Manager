import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/model/favorite/favorite.dart';
import 'package:marozi/model/favorite/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc(FavoriteState initialState) : super(initialState);

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteFetch) {
      yield* _mapFavFetchToState();
    }
  }

  Stream<FavoriteState> _mapFavFetchToState() async* {
    final favRepo = FavoriteRepository();
    List<Favorite> favs = await favRepo.getAllFavorite();
    yield FavoriteLoadSuccess(list: favs);
  }
}
