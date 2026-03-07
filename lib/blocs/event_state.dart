import 'package:event_app/models/event_model.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventSuccess extends EventState {
  final List<Event> events;
  final String? message;
  EventSuccess({required this.events, this.message});
}

class EventFailure extends EventState {
  final String error;
  EventFailure(this.error);
}
