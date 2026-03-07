import 'package:equatable/equatable.dart';
import 'user_model.dart';

class AuthResponse extends Equatable {
  final bool success;
  final String message;
  final User? user;
  final String? token;

  const AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
      'token': token,
    };
  }

  @override
  List<Object?> get props => [success, message, user, token];
}
