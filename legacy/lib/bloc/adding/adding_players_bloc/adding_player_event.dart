part of 'adding_player_bloc.dart';

class AddingPlayerEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetPlayer extends AddingPlayerEvent {
  final Club club;

  GetPlayer(this.club);

  @override
  // TODO: implement props
  List<Object> get props => [club];
}

class ClearAddingPlayer extends AddingPlayerEvent {}
