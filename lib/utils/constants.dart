class AppConstants {
  // API
  static const String baseUrl = 'http://192.168.1.114:3000';

  // User Types
  static const String userTypeAdmin = 'admin';
  static const String userTypeUser = 'user';

  // Error Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Email is invalid';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength =
      'Password must be at least 6 characters';
  static const String fullNameRequired = 'Full name is required';
  static const String passwordMismatch = 'Passwords do not match';
  static const String loginFailed = 'Login failed. Please try again.';
  static const String signupFailed = 'Signup failed. Please try again.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String signupSuccess = 'Signup successful!';
  static const String logoutSuccess = 'Logout successful!';
}
