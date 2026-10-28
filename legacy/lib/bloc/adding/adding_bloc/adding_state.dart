part of 'adding_bloc.dart';

class AddingState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddingInitial extends AddingState {}

class AddingLeagueSelecting extends AddingState {
  final Map<String, List<League>> leagueByNation;

  AddingLeagueSelecting({
    this.leagueByNation,
  });

  AddingLeagueSelecting copyWith({
    Map<String, List<League>> leagueByNation,
    bool isStarting,
    List<Player> subs,
    List<Player> starting,
    Club club,
    List<Player> players,
  }) {
    return AddingLeagueSelecting(
      leagueByNation: leagueByNation ?? this.leagueByNation,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        this.leagueByNation,
      ];
}

class AddingClubsSelecting extends AddingState {
  final Map<String, List<League>> leagueByNation;
  final League league;
  final List<Club> clubs;

  AddingClubsSelecting({this.leagueByNation, this.league, this.clubs});

  AddingClubsSelecting copyWith({
    Map<String, List<League>> leagueByNation,
    League league,
    List<Club> clubs,
  }) {
    return AddingClubsSelecting(
      leagueByNation: leagueByNation ?? this.leagueByNation,
      league: league ?? this.league,
      clubs: clubs ?? this.clubs,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [leagueByNation, league, clubs];
}

class AddingPlayersSelecting extends AddingState {
  final Map<String, List<League>> leagueByNation;
  final League league;
  final List<Club> clubs;
  final Club club;
  final List<Player> players;

  AddingPlayersSelecting(
      {this.leagueByNation, this.league, this.clubs, this.club, this.players});

  AddingPlayersSelecting copyWith({
    Map<String, List<League>> leagueByNation,
    League league,
    List<Club> clubs,
    Club club,
    List<Player> players,
  }) {
    return AddingPlayersSelecting(
      league: league ?? this.league,
      clubs: clubs ?? this.clubs,
      club: club ?? this.club,
      players: players ?? this.players,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [leagueByNation, clubs, club, players, league];
}
