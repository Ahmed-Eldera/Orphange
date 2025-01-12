class Task {
  final String id;
  String eventId;
  final String name;
  final String description;
  final int hours;
  String status; // New property
  final String volunteerEmail; // New field for volunteer email

  Task({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
    required this.hours,
    this.status = "pending", // Default status
    required this.volunteerEmail, // Initialize volunteerEmail
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'description': description,
      'hours': hours,
      'status': status,
      'volunteerEmail': volunteerEmail, // Add volunteerEmail to the map
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      eventId: map['eventId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      hours: map['hours'] ?? 0,
      status: map['status'] ?? 'pending',
      volunteerEmail: map['volunteerEmail'] ?? '', // Ensure volunteerEmail is fetched
    );
  }
}
