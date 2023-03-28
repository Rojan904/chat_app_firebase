class SearchCubitState {
  final bool isJoined;
  final String userId, userName, groupId, groupName;
  SearchCubitState({
    required this.isJoined,
    required this.userId,
    required this.userName,
    required this.groupId,
    required this.groupName,
  });
  factory SearchCubitState.initial() => SearchCubitState(
      isJoined: false, userId: "", userName: "", groupId: "", groupName: "");
  SearchCubitState copyWith({required bool isJoined}) {
    return SearchCubitState(
        isJoined: isJoined,
        userId: userId,
        userName: userName,
        groupId: groupId,
        groupName: groupName);
  }
}
