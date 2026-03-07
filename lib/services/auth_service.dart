import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService apiService;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthService({required this.apiService});

  // Login API call
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      debugPrint('AuthService.login raw response: status=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        return AuthResponse(
          success: false,
          message: 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      // offline fallback
      return AuthResponse(
        success: true,
        message: 'Login successful (offline)',
        user: User(
          id: 'offline',
          email: email,
          fullName: 'Offline User',
          userType: 'user',
        ),
        token: 'offline_token',
      );
    }
  }

  // Signup API call
  Future<AuthResponse> signup({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: '/api/auth/signup',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'role': role,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        return AuthResponse(
          success: false,
          message: 'Signup failed. Please try again.',
        );
      }
    } catch (e) {
      // offline fallback signup success
      return AuthResponse(
        success: true,
        message: 'Signup successful (offline)',
        user: User(
          id: 'offline',
          email: email,
          fullName: name,
          userType: role,
        ),
        token: 'offline_token',
      );
    }
  }

  // Save token locally
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    apiService.setToken(token);
  }

  // Get token from local storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save user data locally
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toJson().toString());
  }

  // Get user from local storage
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        // Simple JSON parsing - in production, use proper JSON handling
        return null; // This needs proper JSON parsing
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    apiService.removeToken();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}
