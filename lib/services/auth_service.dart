import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'package:dio/dio.dart';


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
      debugPrint(
          'AuthService.login raw response: status=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        return AuthResponse(
          success: false,
          message: 'Invalid credentials. Please try again.',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Invalid credentials. Please check your email and password.',
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

    return AuthResponse.fromJson(response.data);

  } catch (e) {

    if (e is DioException) {

      // Email already registered
      if (e.response?.statusCode == 400) {
        return AuthResponse(
          success: false,
          message: e.response?.data['message'] ?? "Email already registered",
        );
      }

      // Other server errors
      if (e.response?.statusCode == 500) {
        return AuthResponse(
          success: false,
          message: "Server error. Please try again later",
        );
      }
    }

    return AuthResponse(
      success: false,
      message: 'Signup failed. Please check your details.',
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
    // encode as JSON string
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Get user from local storage
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        // parse JSON string back to map
        final Map<String, dynamic> data = Map<String, dynamic>.from(
            jsonDecode(userJson) as Map<String, dynamic>);
        return User.fromJson(data);
      } catch (e) {
        debugPrint('AuthService.getUser parse error: $e');
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
