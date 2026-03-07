import 'package:equatable/equatable.dart';
import 'user_model.dart';

class AuthResponse extends Equatable {
  final bool success;
  final String message;
  final User? user;
  final String? token;
  final String? role; // admin/user string from response if provided

  const AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
    this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    // Handle user from different response formats
    User? user;
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    } else if (data?['user'] != null) {
      user = User.fromJson(data!['user']);
    } else if (data != null &&
        (data.containsKey('id') || data.containsKey('email'))) {
      // If data contains user fields directly
      user = User.fromJson(data);
    }

    // Extract role if present in root or data
    String? role;
    if (json['role'] != null) {
      role = json['role'].toString();
    } else if (data != null && data['role'] != null) {
      role = data['role'].toString();
    }

    return AuthResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      user: user,
      token: data?['token'] as String? ?? json['token'] as String?,
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
      'token': token,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [success, message, user, token, role];
}
