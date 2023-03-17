part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}
class GetUserEvent extends HomeEvent{}
class GetUserGroupsEvent extends HomeEvent{
  
}
class CreateGroupEvent extends HomeEvent {
  final String groupName,userName;
  const CreateGroupEvent({required this.groupName,required this.userName});
  
  @override
  List<Object> get props => [groupName,userName];
}
abstract class ApiEvent extends Equatable {
  const ApiEvent();

  @override
  List<Object> get props => [];
}
class GetUserEvents extends ApiEvent{}
class GetUserGroupsEvents extends ApiEvent{
  
}
class CreateGroupEvents extends ApiEvent {
  final String groupName,userName;
  const CreateGroupEvents({required this.groupName,required this.userName});
  
  @override
  List<Object> get props => [groupName,userName];
}

