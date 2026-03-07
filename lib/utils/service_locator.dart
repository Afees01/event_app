import 'package:event_app/blocs/auth_bloc.dart';
import 'package:event_app/services/api_service.dart';
import 'package:event_app/services/auth_service.dart';
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
}
