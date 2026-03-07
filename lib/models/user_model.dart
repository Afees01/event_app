import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String userType; // 'admin' or 'user'

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      userType: json['userType'] as String? ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'userType': userType,
    };
  }

  @override
  List<Object> get props => [id, email, fullName, userType];
}
