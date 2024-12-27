import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hope_home/models/users/donor.dart';
import 'package:hope_home/models/users/userFactory.dart';
import 'package:hope_home/models/users/volunteer.dart';
import 'package:hope_home/models/users/admin.dart';
import 'package:hope_home/models/user.dart';

class UserServiceHelper {


  // Login method
  static Future<String?>  loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String id = userCredential.user!.uid;
      // String type = await _fetchUserType(id);
      // return await UserFactory.fromFirestore(id);
      return id;
    } catch (e) {
      // Handle login failure
      return null;
    }
  }

  // Signup method
   static Future<String?> signupWithEmailPassword(String email, String password, String name, String type) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String id = userCredential.user!.uid;
      await _insertUserIntoDB(id, name, email, type);
      // return await UserFactory.fromFirestore(id);
      return id;
    } catch (e) {
      // Handle signup failure
      return null;
    }
  }

  // Insert user data into Firestore
 static Future<void> _insertUserIntoDB(String id, String name, String email, String type) async {
  try {
    var userCollection = FirebaseFirestore.instance.collection('users');

    // Initialize the common fields
    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'type': type,
      'history': [],  // Common field for both donor and volunteer
    };

    // Add fields specific to Donor or Volunteer
    if (type == 'Volunteer') {
      userData.addAll({
        'skills': [],  // Specific to Volunteer
        'availability': [],  // Specific to Volunteer
      });
    } else if (type == 'Donor') {
      userData.addAll({
        // Donor specific fields can be added here if needed
      });
    }

    // Insert the user data into Firestore
    await userCollection.doc(id).set(userData);
  } catch (e) {
    // Handle insert failure
    print('Error inserting user: $e');
  }
}
 static Future<Map<String, dynamic>?> fetchUserData(String id) async{
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    Map<String, dynamic> data = snapshot.data()!;
    return data;
}
  }


