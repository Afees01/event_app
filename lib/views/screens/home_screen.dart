import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../blocs/auth_state.dart';
import '../../blocs/auth_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventFlow'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            final isAdmin = state.user.userType == 'admin';
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.user.fullName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isAdmin ? Colors.orange[100] : Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAdmin ? 'Admin' : 'User',
                        style: TextStyle(
                          color:
                              isAdmin ? Colors.orange[800] : Colors.blue[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Navigation Options
                    if (isAdmin) ...[
                      _buildButton(
                        context,
                        icon: Icons.dashboard,
                        label: 'Admin Dashboard',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/admin-dashboard');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        context,
                        icon: Icons.add_circle,
                        label: 'Add New Event',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/add-event');
                        },
                      ),
                    ] else ...[
                      _buildButton(
                        context,
                        icon: Icons.event,
                        label: 'Browse Events',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/events');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        context,
                        icon: Icons.my_library_books,
                        label: 'My Registrations',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/my-registrations');
                        },
                      ),
                    ],

                    const SizedBox(height: 48),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(const LogoutEvent());
                        Navigator.of(context).pushReplacementNamed('/welcome');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
