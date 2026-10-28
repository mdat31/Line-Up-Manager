part of 'adding_bloc.dart';

class AddingEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetLeagueByNation extends AddingEvent {}

class LeagueSelect extends AddingEvent {
  final League league;

  LeagueSelect(this.league);

  @override
  // TODO: implement props
  List<Object> get props => [league];
}

class ClubSelect extends AddingEvent {
  final Club club;

  ClubSelect(this.club);

  @override
  // TODO: implement props
  List<Object> get props => [club];
}

class MultiPlayerSel extends AddingEvent {
  final Player player;

  MultiPlayerSel(this.player);

  @override
  // TODO: implement props
  List<Object> get props => [player];
}

class ClubBack extends AddingEvent {}

class LeagueBack extends AddingEvent {}
