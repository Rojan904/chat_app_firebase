import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/database_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetUserGroupsEvent>((event, emit) async {
      emit(const HomeLoading());

      try {
        final group =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getUserGroups();

        emit(HomeLoaded(groups: group));
      } on IOException {
        emit(const HomeError(message: "s"));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
    on<CreateGroupEvent>((event, emit) async {
      emit(const HomeLoading());
      try {
        final sd =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .createGroup(event.userName,
                    FirebaseAuth.instance.currentUser!.uid, event.groupName);
        emit(HomeLoaded(groups: sd));
      } catch (e) {
        HomeError(message: e.toString());
      }
    });
  }
}

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiState.initial()) {
    on<GetUserGroupsEvents>((event, emit) async {
      emit(state.copyWith(status: ApiStatus.loading));

      try {
        final group =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getUserGroups();

        emit(state.copyWith(status: ApiStatus.success, data: group));
      } on IOException {
        emit(state.copyWith(status: ApiStatus.failue));
      } catch (e) {
        emit(state.copyWith(status: ApiStatus.failue));
      }
    });
    on<CreateGroupEvents>((event, emit) async {
      emit(state.copyWith(status: ApiStatus.loading));
      try {
        final sd =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .createGroup(event.userName,
                    FirebaseAuth.instance.currentUser!.uid, event.groupName);
        emit(state.copyWith(status: ApiStatus.success, data: sd));
      } catch (e) {
        emit(state.copyWith(status: ApiStatus.failue));
      }
    });
  }
}
