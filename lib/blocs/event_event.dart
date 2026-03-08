import 'dart:typed_data';

abstract class EventEvent {
  const EventEvent();
}

class CreateEventEvent extends EventEvent {
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;
  final List<int>? imageBytes;
  final String? imageName;

  CreateEventEvent({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl = '',
    this.imageBytes,
    this.imageName,
  });
}

class UpdateEventEvent extends EventEvent {
  final int eventId;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;
  final List<int>? imageBytes;
  final String? imageName;

  UpdateEventEvent({
    required this.eventId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl = '',
    this.imageBytes,
    this.imageName,
  });
}

class DeleteEventEvent extends EventEvent {
  final int eventId;
  DeleteEventEvent(this.eventId);
}

class FetchEventsEvent extends EventEvent {
  const FetchEventsEvent();
}
