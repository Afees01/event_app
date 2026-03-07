import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/registration_bloc.dart';
import '../../blocs/registration_event.dart';
import '../../blocs/registration_state.dart';
import '../widgets/bottom_nav_bar.dart';

class UserRegistrationsScreen extends StatefulWidget {
  const UserRegistrationsScreen({super.key});

  @override
  State<UserRegistrationsScreen> createState() =>
      _UserRegistrationsScreenState();
}

class _UserRegistrationsScreenState extends State<UserRegistrationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RegistrationBloc>().add(FetchMyRegistrationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Registrations'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          if (state is RegistrationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is RegistrationSuccess) {
            if (state.registrations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Registrations Yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Register for events to see them here',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.registrations.length,
              itemBuilder: (context, index) {
                final registration = state.registrations[index];
                return _buildRegistrationCard(context, registration);
              },
            );
          } else if (state is RegistrationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Registrations',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RegistrationBloc>().add(
                            FetchMyRegistrationsEvent(),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildRegistrationCard(BuildContext context, registration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Text(
              registration.eventTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Registration Details
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Date: ${registration.eventDate}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Registrant Name
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Name: ${registration.name}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Email
            Row(
              children: [
                Icon(
                  Icons.email,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Email: ${registration.email}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Phone
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Phone: ${registration.phone}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showEditDialog(context, registration);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showCancelConfirmation(context, registration.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, registration) {
    final nameController = TextEditingController(text: registration.name);
    final emailController = TextEditingController(text: registration.email);
    final phoneController = TextEditingController(text: registration.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Registration'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<RegistrationBloc>().add(
                    UpdateRegistrationEvent(
                      registrationId: registration.id,
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, int registrationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Registration'),
        content: const Text(
          'Are you sure you want to cancel your registration for this event?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Registration'),
          ),
          TextButton(
            onPressed: () {
              context.read<RegistrationBloc>().add(
                    CancelRegistrationEvent(registrationId),
                  );
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel Registration',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
