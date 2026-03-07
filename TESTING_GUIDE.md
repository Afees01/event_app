# 🧪 Testing & Debugging Guide

## Unit Tests for BLoC

### **Setup Test Dependencies**

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.0
  mocktail: ^1.0.0
```

### **Test Auth Service**

```dart
// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:event_app/services/auth_service.dart';
import 'package:event_app/services/api_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      authService = AuthService(apiService: mockApiService);
    });

    test('login returns successful response', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      
      // Mock API response
      when(() => mockApiService.post(
        endpoint: '/auth/user-login',
        data: any(named: 'data'),
      )).thenAnswer((_) async => Response(
        data: {
          'success': true,
          'message': 'Login successful',
          'user': {
            'id': '1',
            'email': email,
            'fullName': 'Test User',
            'userType': 'user',
          },
          'token': 'test_token',
        },
        statusCode: 200,
      ));

      // Act
      final result = await authService.login(
        email: email,
        password: password,
        isAdmin: false,
      );

      // Assert
      expect(result.success, true);
      expect(result.user?.email, email);
      expect(result.token, 'test_token');
    });

    test('login handles error response', () async {
      // Arrange
      when(() => mockApiService.post(
        endpoint: any(named: 'endpoint'),
        data: any(named: 'data'),
      )).thenThrow(Exception('Network error'));

      // Act
      final result = await authService.login(
        email: 'test@example.com',
        password: 'wrong',
        isAdmin: false,
      );

      // Assert
      expect(result.success, false);
      expect(result.message.contains('Error'), true);
    });
  });
}

class MockApiService extends Mock implements ApiService {}
```

### **Test Auth BLoC**

```dart
// test/blocs/auth_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:event_app/blocs/auth_bloc.dart';
import 'package:event_app/services/auth_service.dart';
import 'package:event_app/models/user_model.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      authBloc = AuthBloc(authService: mockAuthService);
    });

    tearDown(() {
      authBloc.close();
    });

    group('LoginEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when login succeeds',
        build: () {
          when(() => mockAuthService.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            isAdmin: any(named: 'isAdmin'),
          )).thenAnswer((_) async => AuthResponse(
            success: true,
            message: 'Login successful',
            user: User(
              id: '1',
              email: 'test@example.com',
              fullName: 'Test User',
              userType: 'user',
            ),
            token: 'test_token',
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(LoginEvent(
          email: 'test@example.com',
          password: 'password123',
          isAdmin: false,
        )),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when login fails',
        build: () {
          when(() => mockAuthService.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            isAdmin: any(named: 'isAdmin'),
          )).thenThrow(Exception('Login failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(LoginEvent(
          email: 'test@example.com',
          password: 'wrong',
          isAdmin: false,
        )),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
        ],
      );
    });

    group('SignupEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when signup succeeds',
        build: () {
          when(() => mockAuthService.signup(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            isAdmin: any(named: 'isAdmin'),
          )).thenAnswer((_) async => AuthResponse(
            success: true,
            message: 'Signup successful',
            user: User(
              id: '2',
              email: 'newuser@example.com',
              fullName: 'New User',
              userType: 'user',
            ),
            token: 'new_token',
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignupEvent(
          email: 'newuser@example.com',
          password: 'password123',
          fullName: 'New User',
          isAdmin: false,
        )),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
      );
    });

    group('CheckAuthStatusEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthAuthenticated] when token exists',
        build: () {
          when(() => mockAuthService.getToken())
              .thenAnswer((_) async => 'valid_token');
          when(() => mockAuthService.getUser())
              .thenAnswer((_) async => User(
                id: '1',
                email: 'test@example.com',
                fullName: 'Test User',
                userType: 'user',
              ));
          return authBloc;
        },
        act: (bloc) => bloc.add(CheckAuthStatusEvent()),
        expect: () => [
          isA<AuthAuthenticated>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthUnauthenticated] when token does not exist',
        build: () {
          when(() => mockAuthService.getToken())
              .thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(CheckAuthStatusEvent()),
        expect: () => [
          isA<AuthUnauthenticated>(),
        ],
      );
    });
  });
}

class MockAuthService extends Mock implements AuthService {}
```

---

## Widget Tests

### **Login Screen Widget Test**

```dart
// test/views/screens/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:event_app/views/screens/login_screen.dart';
import 'package:event_app/blocs/auth_bloc.dart';

void main() {
  group('LoginScreen', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginScreen(isAdmin: false),
        ),
      );
    }

    testWidgets('renders login form correctly', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('validates email field', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      // Try to submit without email
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows loading state during login', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message on login failure', (WidgetTester tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(AuthFailure(error: 'Invalid credentials'));

      await tester.pumpWidget(createWidgetUnderTest());

      // Trigger state change with ScaffoldMessenger
      await tester.pumpWidget(Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          bloc: mockAuthBloc,
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: createWidgetUnderTest(),
        ),
      ));
    });
  });
}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
```

---

## Integration Tests

### **Login Flow Integration Test**

```dart
// test_driver/main.dart
import 'package:flutter/material.dart';
import 'package:event_app/main.dart' as app;

void main() {
  app.main();
}
```

```dart
// integration_test/auth_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:event_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Test', () {
    testWidgets('User can sign up and login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Expect to see welcome screen
      expect(find.text('EventFlow'), findsOneWidget);

      // Tap User Login
      await tester.tap(find.text('User Login'));
      await tester.pumpAndSettle();

      // Navigate to signup
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Fill signup form
      await tester.enterText(
        find.byType(TextFormField).first,
        'John Doe',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'john@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'password123',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'password123',
      );

      // Submit signup
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify home screen is shown
      expect(find.text('John Doe'), findsWidgets);
    });
  });
}
```

---

## Debugging Tips

### **1. Enable Debug Logging**

```dart
// In BLoC
@override
void on<T extends Event>(
  EventHandler<T, State> handler,
) {
  super.on<T>((event) {
    print('📤 Event: $event');
    return handler(event);
  });
}

@override
void emit(State state) {
  print('📥 State: $state');
  super.emit(state);
}
```

### **2. Network Request Logging (Dio)**

```dart
void setupServiceLocator() {
  final apiService = ApiService();
  
  // Add interceptor for logging
  apiService.dio.interceptors.add(
    LoggingInterceptor(),
  );
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📡 [REQUEST] ${options.method} ${options.path}');
    print('📋 Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ [RESPONSE] ${response.statusCode}');
    print('📦 Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ [ERROR] ${err.message}');
    print('📍 Status: ${err.response?.statusCode}');
    super.onError(err, handler);
  }
}
```

### **3. Flutter DevTools**

```bash
flutter pub global activate devtools
flutter pub global run devtools

# Or use directly
flutter run
# Then press 'd' to open DevTools
```

### **4. Local Storage Debugging**

```dart
// Check saved token
final token = await authService.getToken();
print('🔑 Token: $token');

// Clear all saved data for testing
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
print('🗑️  Cleared all preferences');
```

### **5. State Tracking**

```dart
// Print all state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    print('🔄 State changed to: $state');
    if (state is AuthSuccess) {
      print('✅ User: ${state.user.email}');
    }
  },
  child: // ... rest of UI
)
```

---

## Common Test Scenarios

| Scenario | Test Case |
|----------|-----------|
| Valid credentials | Should return user and token |
| Invalid email | Should show email validation error |
| Weak password | Should show password validation error |
| Network error | Should emit AuthFailure state |
| Duplicate email on signup | Should show email exists error |
| Password mismatch on signup | Should show mismatch error |
| Expired token | Should logout and redirect to login |
| Missing auth header | Should reject API request |

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/blocs/auth_bloc_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=integration_test/auth_flow_test.dart
```

---

## CI/CD Testing (GitHub Actions Example)

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter test --coverage
```

---

## Best Practices

✅ Test business logic (BLoC, Services)
✅ Mock external dependencies (API, Storage)
✅ Test error scenarios
✅ Use descriptive test names
✅ Keep tests independent
✅ Use setup and teardown
✅ Test one thing per test
✅ Use coverage tools
✅ Automate with CI/CD

