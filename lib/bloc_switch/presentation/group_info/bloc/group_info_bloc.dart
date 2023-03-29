import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../helper/helper_function.dart';
import '../../../../services/database_service.dart';

part 'group_info_event.dart';
part 'group_info_state.dart';

class GroupInfoBloc extends Bloc<GroupInfoEvent, GroupInfoState> {
  GroupInfoBloc() : super(GroupInfoInitial()) {
    on<GetMembersEvent>((event, emit) async {
      emit(GroupInfoLoading());
      try {
        final members =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getGroupMembers(event.groupId);

        emit(GroupInfoLoaded(members: members));
      } on Exception catch (e) {
        emit(GroupInfoError(error: e.toString()));
      }
    });
    on<LeaveGroupEvent>((event, emit) async {
      try {
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .toggleGroupJoin(event.groupId, event.groupName,
                HelperFunctions.getName(event.adminName));
        emit(LeaveGroupSuccess());
      } on Exception catch (e) {
        emit(GroupInfoError(error: e.toString()));
      }
    });
  }
}
