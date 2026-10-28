part of 'detail_bloc.dart';

class DetailEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DetailFetch extends DetailEvent {
  final String playerId;

  DetailFetch(this.playerId);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateFavorite extends DetailEvent {
  final String playerId;

  UpdateFavorite(this.playerId);

  @override
  // TODO: implement props
  List<Object> get props => [playerId];
}
