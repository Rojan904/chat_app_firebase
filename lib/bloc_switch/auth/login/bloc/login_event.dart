part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginAttemptEvent extends LoginEvent {
  final String email, password;
  const LoginAttemptEvent({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() =>
      'LoginButtonPressed { username: $email, password: $password }';
}

class LoginEmailChangedEvent extends LoginEvent {
  final String email;
  const LoginEmailChangedEvent({required this.email});
  @override
  List<Object> get props => [email];
}

class LoginPwChangedEvent extends LoginEvent {
  final String password;
  const LoginPwChangedEvent({required this.password});
  @override
  List<Object> get props => [password];
}
