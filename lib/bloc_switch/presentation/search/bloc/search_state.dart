part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoaing extends SearchState {}

class SearchSuccess extends SearchState {
  final QuerySnapshot searchSnapshot;
  const SearchSuccess({required this.searchSnapshot});
  @override
  List<Object> get props => [searchSnapshot];
}

class SearchError extends SearchState {
  final String error;
  const SearchError({required this.error});
  @override
  List<Object> get props => [error];
}

class HasJoined extends SearchState {
  final bool hasJoined, isToggled;
  const HasJoined({required this.hasJoined, required this.isToggled});
  @override
  List<Object> get props => [hasJoined, isToggled];
}

class HasNotJoined extends SearchState {
  final bool hasJoined, isToggled;
  const HasNotJoined({required this.hasJoined, required this.isToggled});
  @override
  List<Object> get props => [hasJoined, isToggled];
}

class ButtonInitial extends SearchState {}

class ButtonToggled extends SearchState {}
