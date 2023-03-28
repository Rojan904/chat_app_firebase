import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/database_service.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<GetSearchEvent>((event, emit) async {
      emit(SearchLoaing());
      if (event.keyword.isNotEmpty) {
        try {
          await DatabaseService().searchByName(event.keyword).then((snap) {
            emit(SearchSuccess(searchSnapshot: snap));
          });
        } catch (e) {
          SearchError(error: e.toString());
        }
      }
    });
    on<ToggleJoinEvent>((event, emit) async {
      await DatabaseService(uid: event.userId)
          .toggleGroupJoin(event.groupId, event.groupName, event.userName);
      if (state is HasJoined) {
        emit(const HasNotJoined(hasJoined: false, isToggled: true));
      } else {
        emit(const HasJoined(hasJoined: true, isToggled: true));
      }
    });
    on<HasJoinedEvent>((event, emit) async {
      await DatabaseService(uid: event.userId)
          .isUserJoined(event.groupId, event.groupName)
          .then((value) {
        value == true
            ? emit(HasJoined(hasJoined: value, isToggled: false))
            : emit(HasNotJoined(hasJoined: value, isToggled: false));
      });
    });
  }
}
