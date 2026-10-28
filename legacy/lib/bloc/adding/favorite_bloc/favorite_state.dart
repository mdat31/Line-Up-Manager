part of 'favorite_bloc.dart';

class FavoriteState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoadSuccess extends FavoriteState {
  final List<Favorite> list;

  FavoriteLoadSuccess({this.list});

  @override
  // TODO: implement props
  List<Object> get props => [list];
}

class FavoriteLoadFailed extends FavoriteState {}
