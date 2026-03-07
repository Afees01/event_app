import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String role;

  const SignupEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class ClearErrorEvent extends AuthEvent {
  const ClearErrorEvent();
}
