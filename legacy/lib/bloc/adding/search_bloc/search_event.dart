part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchQuery extends SearchEvent {
  final String query;

  SearchQuery(this.query);

  @override
  // TODO: implement props
  List<Object> get props => [query];
}
