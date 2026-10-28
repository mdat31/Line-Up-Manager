part of 'detail_bloc.dart';

class DetailState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DetailInitial extends DetailState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DetailedLoadSuccess extends DetailState {
  final Player player;
  final String clubUrl;
  final bool isFav;

  DetailedLoadSuccess({this.player, this.clubUrl, this.isFav});

  DetailedLoadSuccess copyWith({
    Player player,
    String clubImageUrl,
    bool isFav,
  }) {
    return DetailedLoadSuccess(
        player: player ?? this.player,
        clubUrl: clubImageUrl ?? this.clubUrl,
        isFav: isFav ?? this.isFav);
  }

  @override
  // TODO: implement props
  List<Object> get props => [player, clubUrl, isFav];
}
