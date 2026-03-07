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
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['DESCRIPTION'] as String? ??
          json['description'] as String? ??
          '',
      location: json['location'] as String? ?? '',
      date: DateTime.parse(json['DATE'] as String? ??
          json['date'] as String? ??
          DateTime.now().toIso8601String()),
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
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
