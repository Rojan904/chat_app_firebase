import 'package:chat_app/bloc_switch/presentation/search/cubit/search_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/database_service.dart';

class SearchCubit extends Cubit<SearchCubitState> {
  SearchCubit() : super(SearchCubitState.initial());
  void toggleJoin(bool newVal, userId, userName, groupId, groupName) async {
    await DatabaseService(uid: userId)
        .toggleGroupJoin(groupId, groupName, userName);
    emit(state.copyWith(isJoined: newVal));
  }
}
