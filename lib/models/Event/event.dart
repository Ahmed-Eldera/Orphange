class Event {
  final String id;
  final String name;
  final String description;
  final String date;
  final int attendance;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.attendance,
  });

  // Constructor to create an Event from Firestore document data
  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      attendance: data['attendance'] ?? 0,
    );
  }

  // Convert Event to a JSON map to save to Firestore

}
