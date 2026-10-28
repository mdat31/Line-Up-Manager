import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/model/player/player.dart';
import 'package:marozi/utils/search_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(SearchState initialState) : super(initialState);

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchQuery) yield* _mapSearchQueryToState(event);
  }

  Stream<SearchState> _mapSearchQueryToState(SearchQuery event) async* {
    List<Player> tempSearchStore = [];
    SearchService().searchByName(event.query).then((snapShot) {
      for (var element in snapShot.docs) {
        tempSearchStore
            .add(Player(name: element.data()['player_name'], id: element.id));
      }
    });
    yield SearchHasData(searching: tempSearchStore);
  }
}
