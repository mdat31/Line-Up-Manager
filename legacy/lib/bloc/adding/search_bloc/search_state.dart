part of 'search_bloc.dart';

class SearchState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchHasData extends SearchState {
  final List<Player> searching;

  SearchHasData({this.searching});

  SearchHasData copyWith(List<Player> searching) {
    return SearchHasData(searching: searching ?? this.searching);
  }

  @override
  // TODO: implement props
  List<Object> get props => [searching];
}

class SearchNoData extends SearchState {}

class SearchLoading extends SearchState {}
