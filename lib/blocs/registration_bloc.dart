import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import '../services/registration_service.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationService registrationService;
  final AuthService authService;

  RegistrationBloc({
    required this.registrationService,
    required this.authService,
  }) : super(RegistrationInitial()) {
    on<RegisterForEventEvent>(_onRegisterForEvent);
    on<UpdateRegistrationEvent>(_onUpdateRegistration);
    on<CancelRegistrationEvent>(_onCancelRegistration);
    on<FetchMyRegistrationsEvent>(_onFetchMyRegistrations);
  }

  Future<void> _onRegisterForEvent(
    RegisterForEventEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    try {
      final token = await authService.getToken();
      if (token == null) {
        emit(RegistrationFailure('User not authenticated'));
        return;
      }

      final response = await registrationService.registerForEvent(
        eventId: event.eventId,
        name: event.name,
        email: event.email,
        phone: event.phone,
        token: token,
      );

      if (response.success) {
        add(FetchMyRegistrationsEvent());
      } else {
        emit(RegistrationFailure(response.message));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  Future<void> _onUpdateRegistration(
    UpdateRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    try {
      final token = await authService.getToken();
      if (token == null) {
        emit(RegistrationFailure('User not authenticated'));
        return;
      }

      final response = await registrationService.updateRegistration(
        registrationId: event.registrationId,
        name: event.name,
        email: event.email,
        phone: event.phone,
        token: token,
      );

      if (response.success) {
        add(FetchMyRegistrationsEvent());
      } else {
        emit(RegistrationFailure(response.message));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  Future<void> _onCancelRegistration(
    CancelRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    try {
      final token = await authService.getToken();
      if (token == null) {
        emit(RegistrationFailure('User not authenticated'));
        return;
      }

      final response = await registrationService.cancelRegistration(
        registrationId: event.registrationId,
        token: token,
      );

      if (response.success) {
        add(FetchMyRegistrationsEvent());
      } else {
        emit(RegistrationFailure(response.message));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  Future<void> _onFetchMyRegistrations(
    FetchMyRegistrationsEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    try {
      final token = await authService.getToken();
      if (token == null) {
        emit(RegistrationFailure('User not authenticated'));
        return;
      }

      final response =
          await registrationService.getMyRegistrations(token: token);

      if (response.success) {
        emit(RegistrationSuccess(
          registrations: response.data,
          message: response.message,
        ));
      } else {
        emit(RegistrationFailure(response.message));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}
