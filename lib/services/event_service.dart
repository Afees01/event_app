import 'package:dio/dio.dart';
import 'package:event_app/models/event_response_model.dart';
import 'package:event_app/models/event_model.dart';
import 'package:event_app/services/api_service.dart';
import 'package:flutter/foundation.dart';

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
    List<int>? imageBytes,
    String? imageName,
  }) async {
    try {
      final formDataMap = {
        'title': title,
        'description': description,
        'location': location,
        'date': date.toIso8601String().split('T')[0],
      };

      final data = FormData.fromMap(formDataMap);

      if (imageBytes != null && imageName != null) {
        data.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(imageBytes, filename: imageName),
        ));
      } else if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
        if (!kIsWeb) {
          data.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(imageUrl, filename: 'event_image.jpg'),
          ));
        }
      }

      final response = await apiService.postMultipart(
        endpoint: '/api/events/create',
        data: data,
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
    List<int>? imageBytes,
    String? imageName,
  }) async {
    try {
      final formDataMap = {
        'title': title,
        'description': description,
        'location': location,
        'date': date.toIso8601String().split('T')[0],
      };

      final data = FormData.fromMap(formDataMap);

      if (imageBytes != null && imageName != null) {
        data.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(imageBytes, filename: imageName),
        ));
      } else if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
        if (!kIsWeb) {
          data.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(imageUrl, filename: 'event_image.jpg'),
          ));
        }
      }

      final response = await apiService.putMultipart(
        endpoint: '/api/events/$eventId/update',
        data: data,
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
        endpoint: '/api/events/$eventId/delete',
        token: token,
      );

      final eventResponse = SingleEventResponse.fromJson(response.data);
      if (!eventResponse.success) {
        throw Exception(eventResponse.message);
      }
    } catch (e) {
      throw Exception('Failed to delete event');
    }
  }
}
