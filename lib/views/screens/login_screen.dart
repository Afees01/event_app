import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../blocs/auth_event.dart';
import '../../blocs/auth_state.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  final bool isAdmin;

  const LoginScreen({
    super.key,
    this.isAdmin = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isAdmin ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    debugPrint('Login button pressed');
    if (_formKey.currentState!.validate()) {
      debugPrint('Form valid, dispatching LoginEvent');
      context.read<AuthBloc>().add(
            LoginEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('EventFlow'),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          debugPrint('LoginScreen listener saw state: $state');
          if (state is AuthSuccess) {
            debugPrint('LoginScreen: AuthSuccess received, navigating now');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Navigate based on user role
            final isAdmin = state.user.userType == 'admin';
            if (isAdmin) {
              Navigator.of(context).pushReplacementNamed('/admin-dashboard');
            } else {
              Navigator.of(context).pushReplacementNamed('/events');
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6366F1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF6366F1),
              tabs: const [
                Tab(text: 'User'),
                Tab(text: 'Admin'),
              ],
            ),
            // Tab View Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // User Login Tab
                  _buildLoginForm(isAdmin: false),
                  // Admin Login Tab
                  _buildLoginForm(isAdmin: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm({required bool isAdmin}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Email Field
            Text(
              'Email Address',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'you@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return AppConstants.emailRequired;
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                  return AppConstants.emailInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Password Field
            Text(
              'Password',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return AppConstants.passwordRequired;
                }
                if (value!.length < 6) {
                  return AppConstants.passwordMinLength;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to forgot password
                },
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 32),

            // Login Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/signup',
                      arguments: isAdmin,
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
