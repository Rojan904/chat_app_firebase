import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_bloc_dart_event.dart';
part 'register_bloc_dart_state.dart';

class RegisterBlocDartBloc extends Bloc<RegisterBlocDartEvent, RegisterBlocDartState> {
  RegisterBlocDartBloc() : super(RegisterBlocDartInitial()) {
    on<RegisterBlocDartEvent>((event, emit) {
    });
  }
}
