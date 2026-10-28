import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/model/club/club.dart';
import 'package:marozi/model/league/league.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/utils/firebase_to_local.dart';

part 'adding_event.dart';
part 'adding_state.dart';

class AddingBloc extends Bloc<AddingEvent, AddingState> {
  AddingBloc(AddingState initialState) : super(initialState);

  @override
  Stream<AddingState> mapEventToState(AddingEvent event) async* {
    if (event is GetLeagueByNation) yield* _mapGetLeagueByNationToState(event);

    if (event is LeagueSelect) yield* _mapLeagueSelectToState(event);

    if (event is ClubSelect) yield* _mapClubSelectToState(event);

    if (event is ClubBack) yield* _mapClubBackToState(event);

    if (event is LeagueBack) yield* _mapLeagueBackToState(event);
  }

  Stream<AddingState> _mapGetLeagueByNationToState(
      GetLeagueByNation event) async* {
    yield AddingInitial();
    final getData = FirebaseToLocal();
    Map<String, List<League>> map = await getData.getLeagueByNation();
    yield AddingLeagueSelecting(
      leagueByNation: map,
    );
  }

  Stream<AddingState> _mapLeagueSelectToState(LeagueSelect event) async* {
    final getData = FirebaseToLocal();
    var currentState = state;
    if (currentState is AddingLeagueSelecting) {
      yield AddingInitial();
      List<Club> clubs = await getData.getClubsByLeague(event.league);
      yield AddingClubsSelecting(
        league: event.league,
        clubs: clubs,
        leagueByNation: currentState.leagueByNation,
      );
    }
  }

  Stream<AddingState> _mapClubSelectToState(ClubSelect event) async* {
    final getPlayers = FirebaseToLocal();

    var currentState = state;
    if (currentState is AddingClubsSelecting) {
      yield AddingInitial();
      List<Player> players = await getPlayers.getPlayersByClub(event.club);
      yield AddingPlayersSelecting(
        club: event.club,
        players: players,
        clubs: currentState.clubs,
        league: currentState.league,
        leagueByNation: currentState.leagueByNation,
      );
    }
  }

  Stream<AddingState> _mapClubBackToState(ClubBack event) async* {
    var currentState = state;
    if (currentState is AddingPlayersSelecting) {
      yield AddingInitial();
      yield AddingClubsSelecting(
          league: currentState.league,
          clubs: currentState.clubs,
          leagueByNation: currentState.leagueByNation);
    }
  }

  Stream<AddingState> _mapLeagueBackToState(LeagueBack event) async* {
    var currentState = state;
    if (currentState is AddingClubsSelecting) {
      yield AddingInitial();
      yield AddingLeagueSelecting(
        leagueByNation: currentState.leagueByNation,
      );
    }
  }
}
