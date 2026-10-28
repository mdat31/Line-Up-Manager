import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'formation_event.dart';
part 'formation_state.dart';

class FormationBloc extends Bloc<FormationEvent, FormationState> {
  FormationBloc(FormationState initialState) : super(initialState);

  @override
  Stream<FormationState> mapEventToState(FormationEvent event) async* {}
}
