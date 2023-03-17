part of 'login_bloc.dart';

//For comparison of data, we required Equatable. it overrides == and hashCode internally, which saves a lot of boilerplate code.
// In Bloc, we have to extend Equatable to States and Events classes to use this functionality.
@immutable
//when we extend our state and events with equatable it prevents duplicate calls and wont rebild widget again.
//this simply compares old state with new state and if there is no changes, no duplicate calls will execute.
//we declare props to compare the values with state.

//we use extend when we want to access all the properties of the second class using inheritance. 
//here, login state is subclass that extends equatable which is super class. 
//Loginstate can access all properties defined in equtable and can override its properties.  
//class extends class and interface extends interface.
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginEssentials extends LoginState {
  final String email;
  const LoginEssentials({required this.email});
  @override
  List<Object> get props => [email];
}

class LoginLoading extends LoginState {}

class LoggedIn extends LoginState {}

class LoginError extends LoginState {
  final String message;
  const LoginError({required this.message});

  @override
  List<Object> get props => [message];
  @override
  String toString() => 'LoginFailure { error: $message }';
}
