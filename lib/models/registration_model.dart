class Registration {
  final int id;
  final int eventId;
  final String eventTitle;
  final String eventDate;
  final String name;
  final String email;
  final String phone;

  Registration({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.eventDate,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : json['id'] ?? 0,
      eventId: json['event_id'] is String
          ? int.tryParse(json['event_id']) ?? 0
          : json['event_id'] ?? 0,
      eventTitle: json['title'] ?? json['eventTitle'] ?? '',
      eventDate: json['DATE'] ?? json['eventDate'] ?? '',
      name: json['NAME'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'title': eventTitle,
      'DATE': eventDate,
      'NAME': name,
      'email': email,
      'phone': phone,
    };
  }
}

class RegistrationResponse {
  final bool success;
  final String message;
  final Registration? data;

  RegistrationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? Registration.fromJson(json['data']) : null,
    );
  }
}

class RegistrationsResponse {
  final bool success;
  final String message;
  final List<Registration> data;

  RegistrationsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegistrationsResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationsResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => Registration.fromJson(item))
          .toList(),
    );
  }
}
