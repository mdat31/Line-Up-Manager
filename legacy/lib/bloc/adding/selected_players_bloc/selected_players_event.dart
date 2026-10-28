part of 'selected_players_bloc.dart';

class SelectedPlayerEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TableUpdate extends SelectedPlayerEvent {
  final bool isStarting;
  final List<Player> starting;
  final List<Player> subs;

  TableUpdate({this.isStarting, this.starting, this.subs});

  @override
  // TODO: implement props
  List<Object> get props => [isStarting, starting, subs];
}

class MultiPlayerSelect extends SelectedPlayerEvent {
  final Player player;

  MultiPlayerSelect(this.player);

  @override
  // TODO: implement props
  List<Object> get props => [player];
}

class SearchSelect extends SelectedPlayerEvent {
  final String playerId;

  SearchSelect(this.playerId);

  @override
  // TODO: implement props
  List<Object> get props => [playerId];
}

class FavoriteSelect extends SelectedPlayerEvent {
  final String id;

  FavoriteSelect(this.id);

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
