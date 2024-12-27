import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/user.dart';


class Donor extends myUser {
  List<String> history; // An array to store donation history

  Donor({
    required String id,
    required String name,
    required String email,
    this.history = const [], // Initialize with an empty list
  }) : super(id: id, name: name, email: email, type: 'Donor');


}
