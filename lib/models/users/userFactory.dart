import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/admin.dart';
import 'package:hope_home/models/users/donor.dart';
import 'package:hope_home/models/users/volunteer.dart';
import 'dart:js_util';


class UserFactory {
  // Factory method to create the appropriate user type
  static myUser createUser(Map<String, dynamic> userData) {
  String id = userData['id'];
  String name = userData['name'];
  String email = userData['email'];
  String type = userData['type'];

  switch (type) {
    case 'Admin':
      return Admin(id: id, name: name, email: email);
    case 'Volunteer':
      return Volunteer(
        id: id,
        name: name,
        email: email,
        skills: List<String>.from(userData['skills'] ?? []), // Convert to List<String>
        availability: List<String>.from(userData['availability'] ?? []), // Convert to List<String>
        history: List<String>.from(userData['history'] ?? []), // Convert to List<String>
      );
    case 'Donor':
      return Donor(
        id: id,
        name: name,
        email: email,
        history: List<String>.from(userData['history'] ?? []), // Convert to List<String>
      );
    default:
      return myUser(id: id, name: name, email: email, type: type);
  }
}

  }

  // Static method to fetch user from Firestore and create an appropriate user object
  // static Future<myUser> fromFirestore(String id) async {
  //   var snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
  //   Map<String, dynamic> data = snapshot.data()!;

  //   // Add the ID to the map
  //   data['id'] = id;

  //   // Create the user object using the map
  //   return createUser(data);
  // }

