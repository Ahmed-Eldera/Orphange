import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/Donation/donation.dart';
import 'package:hope_home/models/user.dart';


class Donor extends myUser {
  List<String> history;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Donor({
    required super.id,
    required super.name,
    required super.email,
    this.history = const [],
  }) : super(type: 'Donor');

  Future<List<Donation>> fetchDonationsByEmail() async {
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
}
