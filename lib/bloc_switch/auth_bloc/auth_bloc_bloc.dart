import 'dart:math';

import 'package:chat_app/bloc_switch/repository/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final UserRepositories repositories;
  AuthBlocBloc(this.repositories) : super(AuthBlocInitial()) {
    on<AppStarted>((event, emit) async {
      final bool hasToken = await repositories.hasToken();
      if (hasToken) {
        emit(AuthBlocAuthenticated());
      } else {
        emit(AuthBlocUnauthenticated());
      }
    });
    on<LoggedIns>((event, emit) async {
      emit(AuthBlocLoading());
      await repositories.persistToken(event.token);
      emit(AuthBlocAuthenticated());
    });
    on<LoggedOut>((event, emit) async {
      emit(AuthBlocLoading());
      await repositories.deleteToken();
      emit(AuthBlocUnauthenticated());
    });
  }
}
