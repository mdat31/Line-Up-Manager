part of 'club_bloc.dart';

class ClubState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ClubInitial extends ClubState {}

class ClubFetchSuccess extends ClubState {
  final League league;
  final List<Club> clubs;

  ClubFetchSuccess({this.league, this.clubs});

  @override
  // TODO: implement props
  List<Object> get props => [league, clubs];
}
