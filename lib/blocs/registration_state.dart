import 'package:event_app/models/registration_model.dart';

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final List<Registration> registrations;
  final String? message;

  RegistrationSuccess({required this.registrations, this.message});
}

class RegistrationFailure extends RegistrationState {
  final String error;

  RegistrationFailure(this.error);
}
