import 'package:cloud_firestore/cloud_firestore.dart';


class Ticket {
  String id;
  String date;
  String userName;
  String eventName;
  List<String> donationTypes; // Added donationTypes attribute
  Ticket({
    required this.id,
    required this.date,
    required this.userName,
    required this.eventName,
    required this.donationTypes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'userName': userName,
      'eventName': eventName,
      'donationTypes': donationTypes,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      userName: map['userName'] ?? '',
      eventName: map['eventName'] ?? '',
      donationTypes: List<String>.from(map['donationTypes'] ?? []), // Handle donationTypes
    );
  }
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection('tickets').doc(id).set(toMap());
  }


}
