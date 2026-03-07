abstract class RegistrationEvent {}

class RegisterForEventEvent extends RegistrationEvent {
  final int eventId;
  final String name;
  final String email;
  final String phone;

  RegisterForEventEvent({
    required this.eventId,
    required this.name,
    required this.email,
    required this.phone,
  });
}

class UpdateRegistrationEvent extends RegistrationEvent {
  final int registrationId;
  final String name;
  final String email;
  final String phone;

  UpdateRegistrationEvent({
    required this.registrationId,
    required this.name,
    required this.email,
    required this.phone,
  });
}

class CancelRegistrationEvent extends RegistrationEvent {
  final int registrationId;

  CancelRegistrationEvent(this.registrationId);
}

class FetchMyRegistrationsEvent extends RegistrationEvent {}
