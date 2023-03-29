part of 'group_info_bloc.dart';

abstract class GroupInfoEvent extends Equatable {
  const GroupInfoEvent();

  @override
  List<Object> get props => [];
}

class GetMembersEvent extends GroupInfoEvent {
  final String groupId;
  const GetMembersEvent({required this.groupId});
  @override
  List<Object> get props => [groupId];
}

class LeaveGroupEvent extends GroupInfoEvent {
  final String groupId, groupName, adminName;
  const LeaveGroupEvent(this.groupId, this.groupName, this.adminName);
  @override
  List<Object> get props => [groupId, groupName, adminName];
}
