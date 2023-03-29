part of 'group_info_bloc.dart';

abstract class GroupInfoState extends Equatable {
  const GroupInfoState();

  @override
  List<Object> get props => [];
}

class GroupInfoInitial extends GroupInfoState {}

class GroupInfoLoading extends GroupInfoState {}

class GroupInfoLoaded extends GroupInfoState {
  final dynamic members;
  const GroupInfoLoaded({required this.members});
  @override
  List<Object> get props => [members];
}

class GroupInfoError extends GroupInfoState {
  final String error;
  const GroupInfoError({required this.error});

  @override
  List<Object> get props => [error];
}
class LeaveGroupSuccess extends GroupInfoState{}