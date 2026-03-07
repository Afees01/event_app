import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/auth_state.dart';
import 'blocs/auth_event.dart';
import 'utils/service_locator.dart';
import 'utils/theme.dart';
import 'views/screens/welcome_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/signup_screen.dart';
import 'views/screens/home_screen.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'EventFlow - Event Management',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const _HomeWrapper(),
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  static Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/login':
        final isAdmin = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(isAdmin: isAdmin),
        );
      case '/signup':
        final isAdmin = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => SignupScreen(isAdmin: isAdmin),
        );
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
    }
  }
}

class _HomeWrapper extends StatelessWidget {
  const _HomeWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated || state is AuthSuccess) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
