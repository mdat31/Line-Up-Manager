import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/model/player/player.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc(TableState initialState) : super(initialState);

  @override
  Stream<TableState> mapEventToState(TableEvent event) async* {
    if (event is PlayerSelect) yield* _mapPlayerSelectToState(event);

    if (event is PlayerDelete) yield* _mapPlayerDeleteToState(event);
  }

  Stream<TableState> _mapPlayerSelectToState(PlayerSelect event) async* {
    var currentState = state;
    if (currentState is TableAddedSuccess) {
      yield event.isStartingSelect
          ? currentState.copyWith(starting: event.player)
          : currentState.copyWith(subs: event.player);
    } else {
      yield event.isStartingSelect
          ? TableAddedSuccess(starting: event.player)
          : TableAddedSuccess(subs: event.player);
    }
  }

  Stream<TableState> _mapPlayerDeleteToState(PlayerDelete event) async* {
    var currentState = state;
    if (currentState is TableAddedSuccess) {
      if (event.isStarting) {
        List<Player> deleted = List.from(currentState.starting);
        deleted.removeAt(event.key);
        yield currentState.copyWith(starting: deleted);
      } else {
        List<Player> deleted = List.from(currentState.subs);
        deleted.removeAt(event.key);
        yield currentState.copyWith(subs: deleted);
      }
    }
  }
}
