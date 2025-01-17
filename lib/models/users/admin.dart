import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/Donation/donation.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/donor.dart';
import 'package:hope_home/models/users/volunteer.dart';

class Admin extends myUser {
  Admin({
    required super.id,
    required super.name,
    required super.email
    })
    : super(type: 'Admin');
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}