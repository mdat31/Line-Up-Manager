part of 'position_bloc.dart';

class PositionEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PositionTestEvent extends PositionEvent {
  final bool isPortrait;

  PositionTestEvent({@required this.isPortrait});

  @override
  // TODO: implement props
  List<Object> get props => [isPortrait];
}

class CreateFormation extends PositionEvent {
  final List<Player> starting;
  final List<Player> subs;
  final bool isPortrait;

  CreateFormation(this.starting, this.subs, this.isPortrait);

  @override
  // TODO: implement props
  List<Object> get props => [starting, isPortrait, subs];
}

class FormationChange extends PositionEvent {
  final int i;

  FormationChange(this.i);

  @override
  // TODO: implement props
  List<Object> get props => [i];
}

class PositionSwap extends PositionEvent {
  final int first;
  final int second;

  PositionSwap(this.first, this.second);

  @override
  // TODO: implement props
  List<Object> get props => [first, second];
}

class DropPlayer extends PositionEvent {
  final Offset offset;
  final int index;
  final double width;
  final double height;

  DropPlayer(this.offset, this.index, this.width, this.height);

  @override
  // TODO: implement props
  List<Object> get props => [offset, index, width, height];
}

class PositionOrientationChange extends PositionEvent {
  final bool isPortrait;

  PositionOrientationChange(this.isPortrait);

  @override
  // TODO: implement props
  List<Object> get props => [isPortrait];
}
