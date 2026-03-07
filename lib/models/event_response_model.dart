import 'event_model.dart';

class EventResponse {
  final bool success;
  final String message;
  final List<Event>? data;

  EventResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Event.fromJson(e)).toList()
          : null,
    );
  }
}

class SingleEventResponse {
  final bool success;
  final String message;
  final Event? data;

  SingleEventResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SingleEventResponse.fromJson(Map<String, dynamic> json) {
    return SingleEventResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? Event.fromJson(json['data']) : null,
    );
  }
}
