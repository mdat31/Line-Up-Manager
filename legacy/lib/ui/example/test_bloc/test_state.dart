part of 'test_bloc.dart';

class TestState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TestInitial extends TestState {}

class TestFetchSuccess extends TestState {
  final List<Test> list;

  TestFetchSuccess({this.list});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
