import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../blocs/auth_bloc.dart';
import '../../blocs/auth_state.dart';
import '../../blocs/auth_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EventFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<List<ConnectivityResult>>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          final isOffline = snapshot.hasData && snapshot.data!.contains(ConnectivityResult.none);
          
          return Column(
            children: [
              if (isOffline)
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'No Internet Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthSuccess || state is AuthAuthenticated) {
                      final user = state is AuthSuccess
                ? state.user
                : (state as AuthAuthenticated).user;
            final isAdmin = user.userType == 'admin';
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 64),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.account_circle, size: 80, color: Colors.grey[400]),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome, ${user.fullName.isNotEmpty ? user.fullName : (user.email.isNotEmpty ? user.email.split('@').first : 'User')}!',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 32),
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

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(const LogoutEvent());
                          Navigator.of(context)
                              .pushReplacementNamed('/welcome');
                        },
                        icon: const Icon(Icons.logout_rounded, size: 24),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.redAccent.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                    )
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
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Ink(
          height: 65,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6366F1),
                Color(0xFF4F46E5),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),

              /// Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 20),

              /// Label
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),

              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
