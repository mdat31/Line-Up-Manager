part of 'table_bloc.dart';

class TableEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PlayerSelect extends TableEvent {
  final List<Player> player;
  final bool isStartingSelect;

  PlayerSelect(this.player, this.isStartingSelect);

  @override
  // TODO: implement props
  List<Object> get props => [player, isStartingSelect];
}

class PlayerDelete extends TableEvent {
  final int key;
  final bool isStarting;

  PlayerDelete(this.key, this.isStarting);

  @override
  // TODO: implement props
  List<Object> get props => [key, isStarting];
}
