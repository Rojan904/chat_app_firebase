part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterAttemptEvent extends RegisterEvent {
  final String fullName, email, password;
  const RegisterAttemptEvent(
      {required this.fullName, required this.email, required this.password});
  @override
  List<Object> get props => [fullName, email, password];
}
