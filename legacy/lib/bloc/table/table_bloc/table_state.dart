part of 'table_bloc.dart';

class TableState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TableInitial extends TableState {}

class TableAddedSuccess extends TableState {
  final List<Player> starting;
  final List<Player> subs;

  TableAddedSuccess({this.starting, this.subs});

  TableAddedSuccess copyWith({
    List<Player> starting,
    List<Player> subs,
  }) {
    return TableAddedSuccess(
      starting: starting ?? this.starting,
      subs: subs ?? this.subs,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [starting, subs];
}
