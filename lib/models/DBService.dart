import 'package:cloud_firestore/cloud_firestore.dart';

 class FirestoreDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data by user ID
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error getting user by ID: $e");
    }
    return null;
  }

// Optionally, you can add more functions to handle other Firestore operations
}
// In your DBService.dart file:
abstract class DatabaseService {
  Future<void> insertUser(String id, String name, String email, String type);
  Future<Map<String, dynamic>?> fetchUserData(String id);
}
