part of 'club_bloc.dart';

class ClubEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetClub extends ClubEvent {
  final League league;

  GetClub(this.league);

  @override
  // TODO: implement props
  List<Object> get props => [league];
}

class ClearClub extends ClubEvent {}
