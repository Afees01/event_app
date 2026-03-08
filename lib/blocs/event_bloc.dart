import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import '../services/event_service.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventService eventService;
  final AuthService authService;

  EventBloc({
    required this.eventService,
    required this.authService,
  }) : super(EventInitial()) {
    on<CreateEventEvent>(_onCreateEvent);
    on<UpdateEventEvent>(_onUpdateEvent);
    on<DeleteEventEvent>(_onDeleteEvent);
    on<FetchEventsEvent>(_onFetchEvents);
  }

  Future<void> _onCreateEvent(
      CreateEventEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final token = await authService.getToken();
      if (token == null) {
        emit(EventFailure('User not authenticated'));
        return;
      }

      await eventService.createEvent(
        title: event.title,
        description: event.description,
        location: event.location,
        date: event.date,
        imageUrl: event.imageUrl,
        imageBytes: event.imageBytes,
        imageName: event.imageName,
        token: token,
      );
      add(FetchEventsEvent());
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onUpdateEvent(
      UpdateEventEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final token = await authService.getToken();
      if (token == null) {
        emit(EventFailure('User not authenticated'));
        return;
      }

      await eventService.updateEvent(
        eventId: event.eventId,
        title: event.title,
        description: event.description,
        location: event.location,
        date: event.date,
        imageUrl: event.imageUrl,
        imageBytes: event.imageBytes,
        imageName: event.imageName,
        token: token,
      );
      add(FetchEventsEvent());
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onDeleteEvent(
      DeleteEventEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final token = await authService.getToken();
      if (token == null) {
        emit(EventFailure('User not authenticated'));
        return;
      }

      await eventService.deleteEvent(event.eventId, token);
      add(FetchEventsEvent());
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  Future<void> _onFetchEvents(
      FetchEventsEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await eventService.fetchEvents();
      emit(EventSuccess(events: events));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }
}
