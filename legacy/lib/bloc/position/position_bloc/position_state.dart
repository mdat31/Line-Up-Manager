part of 'position_bloc.dart';

class PositionState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PositionInitial extends PositionState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PositionSuccess extends PositionState {
  final List<Player> players;
  final List<Player> subs;
  final List<Offset> offsets;
  final List<String> listFormations;
  final int currentPage;
  final String formation;
  final bool isPortrait;

  PositionSuccess({
    this.players,
    this.offsets,
    this.listFormations,
    this.currentPage,
    this.formation,
    this.isPortrait,
    this.subs,
  });

  PositionSuccess copyWith({
    List<Player> players,
    List<Offset> offsets,
    List<String> listFormations,
    int currentPage,
    String formation,
    bool isPortrait,
    List<Player> subs,
  }) {
    return PositionSuccess(
      listFormations: listFormations ?? this.listFormations,
      players: players ?? this.players,
      offsets: offsets ?? this.offsets,
      currentPage: currentPage ?? this.currentPage,
      formation: formation ?? this.formation,
      isPortrait: isPortrait ?? this.isPortrait,
      subs: subs ?? this.subs,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        players,
        offsets,
        listFormations,
        currentPage,
        formation,
        isPortrait,
        subs,
      ];
}
