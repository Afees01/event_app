import 'package:event_app/models/event_response_model.dart';
import 'package:event_app/models/event_model.dart';
import 'package:event_app/services/api_service.dart';

class EventService {
  final ApiService apiService;

  EventService({required this.apiService});

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await apiService.get(endpoint: '/api/events');
      final eventResponse = EventResponse.fromJson(response.data);
      if (eventResponse.success) {
        return eventResponse.data ?? [];
      }
      throw Exception(eventResponse.message);
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<Event> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime date,
    required String imageUrl,
    required String token,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: '/api/events',
        data: {
          'title': title,
          'description': description,
          'location': location,
          'date': date.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
          'imageUrl': imageUrl,
        },
        token: token,
      );

      final eventResponse = SingleEventResponse.fromJson(response.data);
      if (eventResponse.success && eventResponse.data != null) {
        return eventResponse.data!;
      }
      throw Exception(eventResponse.message);
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<Event> updateEvent({
    required int eventId,
    required String title,
    required String description,
    required String location,
    required DateTime date,
    required String imageUrl,
    required String token,
  }) async {
    try {
      final response = await apiService.put(
        endpoint: '/api/events/$eventId',
        data: {
          'title': title,
          'description': description,
          'location': location,
          'date': date.toIso8601String().split('T')[0],
          'imageUrl': imageUrl,
        },
        token: token,
      );

      final eventResponse = SingleEventResponse.fromJson(response.data);
      if (eventResponse.success && eventResponse.data != null) {
        return eventResponse.data!;
      }
      throw Exception(eventResponse.message);
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(int eventId, String token) async {
    try {
      final response = await apiService.delete(
        endpoint: '/api/events/$eventId',
        token: token,
      );

      final eventResponse = SingleEventResponse.fromJson(response.data);
      if (!eventResponse.success) {
        throw Exception(eventResponse.message);
      }
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
