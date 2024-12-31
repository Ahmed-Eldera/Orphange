class Ticket {
  String id;
  String date;
  String userName;
  String eventName;

  Ticket({
    required this.id,
    required this.date,
    required this.userName,
    required this.eventName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'userName': userName,
      'eventName': eventName,
    };
  }

  // Added toJson method to match the naming convention
  Map<String, dynamic> toJson() {
    return toMap(); // Reuse toMap here for simplicity
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      date: map['date'],
      userName: map['userName'],
      eventName: map['eventName'],
    );
  }
}
