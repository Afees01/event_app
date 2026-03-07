import 'package:event_app/models/registration_model.dart';
import 'package:event_app/services/api_service.dart';

class RegistrationService {
  final ApiService apiService;

  RegistrationService({required this.apiService});

  Future<RegistrationResponse> registerForEvent({
    required int eventId,
    required String name,
    required String email,
    required String phone,
    required String token,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: '/api/registrations/$eventId',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
        },
        token: token,
      );

      return RegistrationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to register for event: $e');
    }
  }

  Future<RegistrationResponse> updateRegistration({
    required int registrationId,
    required String name,
    required String email,
    required String phone,
    required String token,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: '/api/registrations/$registrationId/update',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
        },
        token: token,
      );

      return RegistrationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update registration: $e');
    }
  }

  Future<RegistrationResponse> cancelRegistration({
    required int registrationId,
    required String token,
  }) async {
    try {
      final response = await apiService.post(
        endpoint: '/api/registrations/$registrationId/delete',
        data: {},
        token: token,
      );

      return RegistrationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to cancel registration: $e');
    }
  }

  Future<RegistrationsResponse> getMyRegistrations({
    required String token,
  }) async {
    try {
      final response = await apiService.get(
        endpoint: '/api/registrations/me',
        token: token,
      );

      return RegistrationsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch registrations: $e');
    }
  }
}
