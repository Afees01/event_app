import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(const AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignupEvent>(_onSignupEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<ClearErrorEvent>(_onClearErrorEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final response = await authService.login(
        email: event.email,
        password: event.password,
      );

      if (response.success && response.user != null && response.token != null) {
        // Save token locally (you can use shared_preferences)
        await authService.saveToken(response.token!);
        await authService.saveUser(response.user!);

        emit(AuthSuccess(
          user: response.user!,
          token: response.token!,
          message: response.message,
        ));
      } else {
        emit(AuthFailure(error: response.message));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSignupEvent(
      SignupEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final response = await authService.signup(
        email: event.email,
        password: event.password,
        name: event.name,
        role: event.role,
      );

      if (response.success && response.user != null && response.token != null) {
        // Save token locally
        await authService.saveToken(response.token!);
        await authService.saveUser(response.user!);

        emit(AuthSuccess(
          user: response.user!,
          token: response.token!,
          message: response.message,
        ));
      } else {
        emit(AuthFailure(error: response.message));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await authService.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await authService.getToken();
      final user = await authService.getUser();

      if (token != null && user != null) {
        emit(AuthAuthenticated(user: user, token: token));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onClearErrorEvent(
    ClearErrorEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthInitial());
  }
}
