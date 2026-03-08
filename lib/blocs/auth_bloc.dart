import 'package:event_app/models/user_model.dart';
import 'package:flutter/material.dart';
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
    debugPrint('AuthBloc: received LoginEvent for ${event.email}');
    emit(const AuthLoading());
    try {
      final response = await authService.login(
        email: event.email,
        password: event.password,
      );
      debugPrint(
          'AuthBloc: login response: success=${response.success}, message=${response.message}');
      debugPrint(
          'AuthBloc: login user=${response.user}, token=${response.token}');

      if (response.success) {
        // some backends may not return user/token; provide fallbacks
        String userType = 'user';
        if (response.user != null) {
          userType = response.user!.userType;
        } else if (response.role != null) {
          userType = response.role!.toLowerCase();
        }

        final user = response.user ??
            User(
              id: 'unknown',
              email: event.email,
              fullName: '',
              userType: userType,
            );
        final token = response.token ?? '';

        if (response.user == null || response.token == null) {
          debugPrint(
              'AuthBloc: login success but missing user/token, using defaults');
        }

        // Save token locally (you can use shared_preferences)
        await authService.saveToken(token);
        await authService.saveUser(user);

        emit(AuthSuccess(
          user: user,
          token: token,
          message: response.message,
        ));
      } else {
        emit(AuthFailure(error: response.message));
      }
    } catch (e) {
      debugPrint('AuthBloc: login threw exception: $e');
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

      if (response.success) {
        emit(SignupSuccess(message: response.message));
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
