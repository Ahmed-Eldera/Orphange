import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/DBService.dart'; // Import the abstract class

class FirestoreDatabaseService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Insert a new user
  @override
  Future<void> insertUser(String id, String name, String email, String type) async {
    try {
      var userCollection = _firestore.collection('users');
      Map<String, dynamic> userData = {
        'id': id,
        'name': name,
        'email': email,
        'type': type,
        'history': [], // Common field for both donor and volunteer
      };

      if (type == 'Volunteer') {
        userData.addAll({
          'skills': [],
          'availability': [],
        });
      }

      await userCollection.doc(id).set(userData);
    } catch (e) {
      print('Error inserting user: $e');
    }
  }

  // Fetch user data by user ID
  @override
  Future<Map<String, dynamic>?> fetchUserData(String id) async {
    try {
      var snapshot = await _firestore.collection('users').doc(id).get();
      return snapshot.data();
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Optional: Fetch user data by user ID (without interface)
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        print('User Data Fetched: ${userDoc.data()}');
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error getting user by ID: $e");
    }
    return null;
  }
}
