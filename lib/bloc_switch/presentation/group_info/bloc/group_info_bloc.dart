import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'group_info_event.dart';
part 'group_info_state.dart';

class GroupInfoBloc extends Bloc<GroupInfoEvent, GroupInfoState> {
  GroupInfoBloc() : super(GroupInfoInitial()) {
    on<GroupInfoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
