import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../blocs/auth_state.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthSuccess && state is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }

        final user = state is AuthSuccess
            ? state.user
            : (state as AuthAuthenticated).user;
        final isAdmin = user.userType == 'admin';

        if (isAdmin) {
          return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/home');
                  break;
                case 1:
                  Navigator.of(context)
                      .pushReplacementNamed('/admin-dashboard');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
            ],
          );
        } else {
          return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/events');
                  break;
                case 1:
                  Navigator.of(context)
                      .pushReplacementNamed('/my-registrations');
                  break;
                case 2:
                  Navigator.of(context).pushReplacementNamed('/home');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'My Registrations',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
            ],
          );
        }
      },
    );
  }
}
