abstract class EventEvent {
  const EventEvent();
}

class CreateEventEvent extends EventEvent {
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;

  CreateEventEvent({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imageUrl,
  });
}

class UpdateEventEvent extends EventEvent {
  final int eventId;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;

  UpdateEventEvent({
    required this.eventId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imageUrl,
  });
}

class DeleteEventEvent extends EventEvent {
  final int eventId;
  DeleteEventEvent(this.eventId);
}

class FetchEventsEvent extends EventEvent {
  const FetchEventsEvent();
}
