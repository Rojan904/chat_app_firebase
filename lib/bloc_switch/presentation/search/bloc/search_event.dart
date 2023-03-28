part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetSearchEvent extends SearchEvent {
  final String keyword;

  const GetSearchEvent({required this.keyword});

  @override
  List<Object> get props => [keyword];
}

enum ButtonState { initial, toggled }

class ToggleJoinEvent extends SearchEvent {
  final bool isToggled;
  final String userId, groupId, groupName, userName;
  const ToggleJoinEvent(
      {required this.isToggled,
      required this.userId,
      required this.groupId,
      required this.groupName,
      required this.userName});
  @override
  List<Object> get props => [isToggled,userId, groupId, groupName, userName];
}

class HasJoinedEvent extends SearchEvent {
  final String userId, groupId, groupName;
  const HasJoinedEvent(
      {required this.userId,
      required this.groupId,
      required this.groupName,
    });
  @override
  List<Object> get props => [userId, groupId, groupName, ];
}
