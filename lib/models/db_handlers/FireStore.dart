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
import '../state/state_types.dart';
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
        // Common field for both donor and volunteer
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


  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(
          userId).get();
      if (userDoc.exists) {
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
          .where('type', isEqualTo: 'Donor')
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
          .where('type', isEqualTo: 'Volunteer')
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



// Fetch donations by donor email


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

  Future<List<Event>> fetchAllEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Failed to fetch events: $e');
      return []; // Return an empty list instead of null
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

   Future<List<Beneficiary>> fetchBeneficiaries() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('beneficiaries').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Beneficiary(
          id: doc.id,
          name: data['name'],
          age: data['age'],
          needs: data['needs'],
          allocatedBudget: (data['allocatedBudget'] is int)
              ? (data['allocatedBudget'] as int).toDouble()
              : data['allocatedBudget'] as double,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching beneficiaries: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      print('Error fetching user by email: $e');
    }
    return null;
  }
  Future<Task?> fetchTaskById(String taskId, String eventId) async {
    try {
      final taskDoc = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskDoc.exists) {
        return Task.fromMap(taskDoc.data() as Map<String, dynamic>, taskDoc.id);
      }
    } catch (e) {
      print('Error fetching task by ID: $e');
    }
    return null;
  }
  Future<bool> checkConnection() async {
    try {
      await _firestore.collection('health_check').get();
      return true;
    } catch (e) {
      print("Database connection failed: $e");
      return false;
    }
  }

  Future<void> notifyAdmin(String requestId, String message) async {
    try {
      await _firestore.collection('notifications').add({
        'requestId': requestId,
        'message': message,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print("Failed to notify admin: $e");
    }
  }
  Future<double> getTotalDonations() async {
    try {
      // Fetch all donations
      final List<Donation> donations = await fetchAllDonations();

      // Fold over the list to calculate the total
      return donations.fold<double>(0.0, (double sum, Donation donation) => sum + donation.amount);
    } catch (e) {
      print('Error calculating total donations: $e');
      return 0.0;
    }
  }

  Future<Map<String, double>> fetchTotalDonationsByDonor() async {
    try {
      final List<Donation> donations = await fetchAllDonations();
      Map<String, double> donorTotals = {};

      for (var donation in donations) {
        donorTotals[donation.donorEmail] =
            (donorTotals[donation.donorEmail] ?? 0) + donation.amount;
      }
      return donorTotals;
    } catch (e) {
      print('Error fetching total donations by donor: $e');
      return {};
    }
  }
  Future<List<Task>> fetchTasksByVolunteerEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('tasks')
          .where('volunteerEmail', isEqualTo: email)
          .get();

      return querySnapshot.docs.map((doc) {
        return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching tasks by volunteer email: $e');
      return [];
    }
  }
  Future<List<Task>> fetchTasksParticipated(String email) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('tasks')
          .where('volunteerEmail', isEqualTo: email)
          .get();

      return querySnapshot.docs.map((doc) {
        return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching participated tasks: $e');
      return [];
    }
  }
  Stream<List<Map<String, dynamic>>> fetchTicketsStream() {
    return _firestore.collection('tickets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}