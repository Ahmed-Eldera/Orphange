import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/user.dart';


class Donor extends myUser {
  List<String> history; // An array to store donation history

  Donor({
    required super.id,
    required super.name,
    required super.email,
    this.history = const [], // Initialize with an empty list
  }) : super(type: 'Donor');


}
