import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/user.dart';


class Volunteer extends myUser {
  List<String> skills;
  List<String> availability;
  List<String> history;

  Volunteer({
    required super.id,
    required super.name,
    required super.email,
    required this.skills,
    required this.availability,
    this.history = const [],
  }) : super(type: 'Volunteer');

}
