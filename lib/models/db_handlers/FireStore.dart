import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/db_handlers/DBService.dart';
import 'package:hope_home/models/event.dart';
import 'package:hope_home/controllers/eventsProxy.dart';

import '../Donation/donation.dart';
import '../users/donor.dart';

class FirestoreDatabaseService implements DatabaseService {
  // Private static instance
  static final FirestoreDatabaseService _instance = FirestoreDatabaseService._internal();

  // Factory constructor to return the single instance
  factory FirestoreDatabaseService() {
    return _instance;
  }

  // Private constructor
  FirestoreDatabaseService._internal();

  // Firestore instance
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

  Future<List<Donor>> fetchAllDonors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'donor')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Ensure 'id' field is included
        return Donor(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          history: List<String>.from(data['history'] ?? []),
        );
      }).toList();
    } catch (e) {
      print('Error fetching donors: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessagesForRecipient(String recipientName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('messages')
          .where('recipient', isEqualTo: recipientName)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include document ID
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }
// Add a new donation to Firestore
  Future<void> addDonation(Donation donation) async {
    try {
      await _firestore.collection('donations').add(donation.toJson());
    } catch (e) {
      print('Error adding donation: $e');
    }
  }

// Fetch donations by donor email
  Future<List<Donation>> fetchDonationsByEmail(String email) async {
    try {
      final snapshot = await _firestore
          .collection('donations')
          .where('donorEmail', isEqualTo: email)
          .get();

      return snapshot.docs.map((doc) {
        return Donation.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching donations: $e');
      return [];
    }
  }
  Future<List<Donation>> fetchAllDonations() async {
    try {
      final snapshot = await _firestore.collection('donations').get();

      return snapshot.docs.map((doc) {
        return Donation.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching all donations: $e');
      return [];
    }
  }


  Future<List<Event>?> fetchEvents(String userType) async {
    return EventsProxy().fetchEvents(userType);
  }

  Future<List<Event>?> fetchAllEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  // Filter events to only include those happening this week

}