import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/Donation/donationAdapter.dart';
import 'package:hope_home/models/db_handlers/DBService.dart';
import 'package:hope_home/models/Event/event.dart';
import 'package:hope_home/controllers/eventsProxy.dart';
import 'package:hope_home/models/users/volunteer.dart';

import '../Donation/donation.dart';
import '../Event/request.dart';
import '../Event/task.dart';
import '../beneficiary.dart';
import '../state/pending_state.dart';
import '../state/request_state.dart';
import '../users/donor.dart';

class FirestoreDatabaseService implements DatabaseService {
  // Private static instance
  static final FirestoreDatabaseService _instance = FirestoreDatabaseService
      ._internal();

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
  Future<void> insertUser(String id, String name, String email,
      String type) async {
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
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(
          userId).get();
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

  Future<List<Volunteer>> fetchAllVolunteers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'volunteer')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Ensure 'id' field is included
        return Volunteer(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          skills: [],
          availability: [],
          // history: List<String>.from(data['history'] ?? []),
        );
      }).toList();
    } catch (e) {
      print('Error fetching donors: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessagesForRecipient(
      String recipientID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('messages')
          .where('recipient', isEqualTo: recipientID)
          .orderBy('timestamp', descending: true)
          .get();
      Iterable<Map<String, dynamic>> messages = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include document ID
        return data;
      });
      return messages.toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

// Add a new donation to Firestore
  Future<void> addDonation(DonationAdapter donation) async {
    try {
      await _firestore.collection('donations').add(donation.ToFireStore());
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
  // Save a new request
  Future<void> saveRequest(Request request, String eventId) async {
    try {
      await _firestore
          .collection('events') // Navigate to events
          .doc(eventId) // Select the event
          .collection('tasks') // Access tasks
          .doc(request.taskId) // Select the task
          .collection('requests') // Access requests under the task
          .doc(request.id) // Use the request ID
          .set(request.toMap()); // Save the request details
      print("Request saved successfully under event $eventId and task ${request.taskId}");
    } catch (e) {
      print('Failed to save request: $e');
      throw Exception('Failed to save request');
    }
  }


// Fetch all requests
  Future<List<Request>> fetchAllRequests() async {
    final snapshot = await _firestore.collectionGroup('requests').get();
    return snapshot.docs.map((doc) => Request.fromMap(doc.data())).toList();
  }

// Fetch requests by volunteer
  Future<List<Request>> fetchRequestsByVolunteer(String volunteerId) async {
    try {
      final querySnapshot = await _firestore.collectionGroup('requests')
          .where('volunteerId', isEqualTo: volunteerId)
          .get();

      return querySnapshot.docs.map((doc) {
        return Request.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Failed to fetch requests: $e');
      return [];
    }
  }

  Future<void> updateRequestDetails(Request request) async {
    try {
      await _firestore
          .collection('events')
          .doc(request.eventId)
          .collection('tasks')
          .doc(request.taskId)
          .collection('requests')
          .doc(request.id)
          .update({
        'details': request.details,
      });
      print("Request details updated successfully for ${request.id}");
    } catch (e) {
      print("Failed to update request details: $e");
      throw Exception("Failed to update request details");
    }
  }

// Update request state
  Future<void> updateRequestState(Request request) async {
    try {
      final docPath = 'events/${request.eventId}/tasks/${request.taskId}/requests/${request.id}';
      print("Updating request state at path: $docPath");

      await _firestore
          .collection('events')
          .doc(request.eventId) // Ensure eventId is used
          .collection('tasks')
          .doc(request.taskId)
          .collection('requests')
          .doc(request.id)
          .update({'state': request.getStateName()}); // Update the state

      print("Request state updated successfully for ${request.id}");
    } catch (e) {
      print("Failed to update request state: $e");
      throw Exception("Failed to update request state");
    }
  }


// Helper to map state name to state object
  RequestState _mapState(String state) {
    switch (state) {
      case 'Approved':
        return ApprovedState();
      case 'Rejected':
        return RejectedState();
      default:
        return PendingState();
    }
  }
  Future<void> saveTask(Task task) async {
    try {
      await _firestore
          .collection('events')
          .doc(task.eventId) // Ensure eventId is set correctly
          .collection('tasks')
          .doc(task.id)
          .set(task.toMap());
      print("Task ${task.name} saved successfully under event ${task.eventId}.");
    } catch (e) {
      throw Exception('Failed to save task: $e');
    }
  }


  Future<List<Task>> fetchTasksByEvent(String eventId) async {
    final snapshot = await _firestore
        .collection('events')
        .doc(eventId)
        .collection('tasks')
        .get();

    return snapshot.docs.map((doc) => Task.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchAllTasksWithEventNames() async {
    try {
      // Fetch all tasks
      final querySnapshot = await _firestore.collectionGroup('tasks').get();

      List<Map<String, dynamic>> tasksWithEventNames = [];
      for (var taskDoc in querySnapshot.docs) {
        final taskData = taskDoc.data() as Map<String, dynamic>;
        final eventId = taskData['eventId'];

        // Fetch the event details for the corresponding eventId
        final eventDoc = await _firestore.collection('events').doc(eventId).get();
        if (eventDoc.exists) {
          final eventData = eventDoc.data() as Map<String, dynamic>;

          // Combine task and event details
          tasksWithEventNames.add({
            'task': Task.fromMap(taskData, taskDoc.id),
            'eventName': eventData['name'] ?? 'Unknown Event',
          });
        }
      }
      return tasksWithEventNames;
    } catch (e) {
      throw Exception('Failed to fetch tasks with event names: $e');
    }
  }
  Future<List<Task>> fetchAllTasks() async {
    final querySnapshot = await _firestore.collectionGroup('tasks').get();

    return querySnapshot.docs.map((doc) {
      return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    await _firestore.collection('beneficiaries').doc(beneficiary.id).set(beneficiary.toMap());
  }

  Future<void> updateBeneficiary(Beneficiary beneficiary) async {
    await _firestore.collection('beneficiaries').doc(beneficiary.id).update(beneficiary.toMap());
  }

  Future<List<Beneficiary>> fetchBeneficiaries() async {
    QuerySnapshot snapshot = await _firestore.collection('beneficiaries').get();
    return snapshot.docs.map((doc) => Beneficiary.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> deleteBeneficiary(String id) async {
    await _firestore.collection('beneficiaries').doc(id).delete();
  }




}