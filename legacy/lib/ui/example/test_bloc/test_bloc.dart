import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marozi/ui/example/test.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc(TestState initialState) : super(initialState);

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is GetTest) {
      yield TestFetchSuccess();
    }
  }
}
