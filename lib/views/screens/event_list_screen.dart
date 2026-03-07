import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/event_bloc.dart';
import '../../blocs/event_state.dart';
import '../../models/event_model.dart';
import '../widgets/bottom_nav_bar.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventSuccess) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final Event event = state.events[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/event-details', arguments: event);
                  },
                );
              },
            );
          } else if (state is EventFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No events found.'));
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
