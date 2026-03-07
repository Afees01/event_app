import 'package:event_app/blocs/auth_bloc.dart';
import 'package:event_app/blocs/event_bloc.dart';
import 'package:event_app/blocs/registration_bloc.dart';
import 'package:event_app/services/api_service.dart';
import 'package:event_app/services/auth_service.dart';
import 'package:event_app/services/event_service.dart';
import 'package:event_app/services/registration_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register API Service
  getIt.registerSingleton<ApiService>(ApiService());

  // Register Auth Service
  getIt.registerSingleton<AuthService>(
    AuthService(apiService: getIt<ApiService>()),
  );

  // Register Auth BLoC
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(authService: getIt<AuthService>()),
  );

  // Register Event service & bloc
  getIt.registerSingleton<EventService>(
    EventService(apiService: getIt<ApiService>()),
  );

  getIt.registerSingleton<EventBloc>(
    EventBloc(
      eventService: getIt<EventService>(),
      authService: getIt<AuthService>(),
    ),
  );

  // Register Registration service & bloc
  getIt.registerSingleton<RegistrationService>(
    RegistrationService(apiService: getIt<ApiService>()),
  );

  getIt.registerSingleton<RegistrationBloc>(
    RegistrationBloc(
      registrationService: getIt<RegistrationService>(),
      authService: getIt<AuthService>(),
    ),
  );
}
