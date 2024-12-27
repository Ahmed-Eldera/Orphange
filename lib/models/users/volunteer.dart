import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/user.dart';


class Volunteer extends myUser {
  List<String> skills;
  List<String> availability;
  List<String> history; // An array to store task history

  Volunteer({
    required String id,
    required String name,
    required String email,
    required this.skills,
    required this.availability,
    this.history = const [], // Initialize with an empty list
  }) : super(id: id, name: name, email: email, type: 'Volunteer');

}
