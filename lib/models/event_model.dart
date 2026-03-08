import '../services/api_service.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String? imageUrl;
  final DateTime? createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl,
    this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] as String,
      description: json['DESCRIPTION'] as String? ??
          json['description'] as String? ??
          '',
      location: json['location'] as String? ?? '',
      date: DateTime.parse(json['DATE'] as String? ??
          json['date'] as String? ??
          DateTime.now().toIso8601String()),
      imageUrl: _processImageUrl((json['image'] ?? json['imageUrl']) as String?),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  static String? _processImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    String normalizedUrl = url.replaceAll('\\', '/');
    if (normalizedUrl.startsWith('http') || normalizedUrl.startsWith('https')) return normalizedUrl;
    if (normalizedUrl.startsWith('/')) return '${ApiService.baseUrl}$normalizedUrl';
    return '${ApiService.baseUrl}/$normalizedUrl';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String().split('T')[0],
      'imageUrl': imageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
