import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/DBService.dart';

class FirestoreDatabaseService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> insertUser(String id, String name, String email, String type) async {
    try {
      var userCollection = _firestore.collection('users');
      Map<String, dynamic> userData = {
        'id':id,
        'name': name,
        'email': email,
        'type': type,
        'history': [],  // Common field for both donor and volunteer
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

  @override
  Future<Map<String, dynamic>?> fetchUserData(String id) async {
    var snapshot = await _firestore.collection('users').doc(id).get();
    return snapshot.data();
  }
}
