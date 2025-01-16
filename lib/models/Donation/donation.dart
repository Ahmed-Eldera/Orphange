import 'package:cloud_firestore/cloud_firestore.dart';

import 'donationAdapter.dart';

class Donation {
  final String id;
  final String donorName;
  final String donorEmail;
  final double amount;
  final String method;
  final String date;

  Donation({
    required this.id,
    required this.donorName,
    required this.donorEmail,
    required this.amount,
    required this.method,
    required this.date,
  });

  factory Donation.fromJson(Map<String, dynamic> data, String id) {
    return Donation(
      id: id,
      donorName: data['donorName'] as String,
      donorEmail: data['donorEmail'] as String,
      amount: (data['amount'] is int)
          ? (data['amount'] as int).toDouble()
          : data['amount'] as double,
      method: data['method'] as String,
      date: data['date'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'donorName': donorName,
      'donorEmail': donorEmail,
      'amount': amount,
      'method': method,
      'date': date,
    };
  }
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDonation() async {
    try {
      DonationAdapter adapter = DonationAdapter(this);
      await _firestore.collection('donations').add(adapter.ToFireStore());
    } catch (e) {
      print('Error adding donation: $e');
      throw Exception('Failed to add donation');
    }
  }

}
