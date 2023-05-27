part of 'auth_bloc_bloc.dart';

abstract class AuthBlocEvent extends Equatable {
  const AuthBlocEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthBlocEvent {}

class LoggedIns extends AuthBlocEvent {
  final String token;
  const LoggedIns(this.token);
  @override
  List<Object> get props => [token];
  @override
  String toString() => "Loggedin {$token}";
}

class LoggedOut extends AuthBlocEvent {}
