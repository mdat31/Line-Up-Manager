part of 'adding_player_bloc.dart';

class AddingPlayerState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddingPlayerInitial extends AddingPlayerState {}

class PlayerFetchSuccess extends AddingPlayerState {
  final Club club;
  final List<Player> players;

  PlayerFetchSuccess({this.club, this.players});

  @override
  // TODO: implement props
  List<Object> get props => [club, players];
}
