part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  final dynamic groups;
  const HomeLoaded({required this.groups});
  @override
  List<Object> get props => [groups];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
  @override
  String toString() => 'Failure { error: $message }';
}

class CreateGroupSuccess extends HomeState {}

enum ApiStatus { initial, loading, success, failue }

extension ApiStateX on ApiStatus {
  bool get isInitial => this == ApiStatus.initial;
  bool get isLoading => this == ApiStatus.loading;
  bool get isSuccess => this == ApiStatus.success;
  bool get isFailure => this == ApiStatus.failue;
}

class ApiState {
  final dynamic data;
  final bool isLoading;
  final String error;
  final ApiStatus status;

  ApiState(
      {this.status = ApiStatus.initial,
      this.data,
      this.isLoading = false,
      this.error = ""});
  factory ApiState.initial() => ApiState(
      status: ApiStatus.initial, data: "", isLoading: false, error: "");
  ApiState copyWith(
      {dynamic data, bool? isLoading, String? error, ApiStatus? status}) {
    return ApiState(
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        status: status ?? this.status);
  }
}
