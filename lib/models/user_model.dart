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
    // Handle both 'role' and 'userType' from API
    final role = json['role'] ?? json['userType'] ?? 'user';

    return User(
      id: json['id'].toString(),
      email: json['email'] as String? ?? '',
      fullName:
          json['fullName'] as String? ?? json['full_name'] as String? ?? '',
      userType: role.toString().toLowerCase(), // Ensure it's 'admin' or 'user'
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
