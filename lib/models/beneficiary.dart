import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/db_handlers/FireStore.dart';

class Beneficiary {
  String id;
  String name;
  int age;
  String needs;
  double allocatedBudget;

  Beneficiary({
    required this.id,
    required this.name,
    required this.age,
    required this.needs,
    required this.allocatedBudget,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'needs': needs,
      'allocatedBudget': allocatedBudget,
    };
  }

  factory Beneficiary.fromMap(Map<String, dynamic> map) {
    return Beneficiary(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      needs: map['needs'],
      allocatedBudget: (map['allocatedBudget'] is int)
          ? (map['allocatedBudget'] as int).toDouble()
          : map['allocatedBudget'] as double,
    );
  }

  static final _firestoreDatabase = FirestoreDatabaseService();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addBeneficiary(Beneficiary beneficiary) async {
    await _firestore.collection('beneficiaries').doc(beneficiary.id).set(beneficiary.toMap());
  }

  static Future<void> deleteBeneficiary(String id) async {
    await _firestore.collection('beneficiaries').doc(id).delete();
  }
  static Future<void> updateBeneficiary(Beneficiary beneficiary) async {
    try {
      await _firestore.collection('beneficiaries').doc(beneficiary.id).update(beneficiary.toMap());
    } catch (e) {
      print('Error updating beneficiary: $e');
      throw Exception('Failed to update beneficiary');
    }
  }
  static Future<double> getTotalDonations() async {
    try {
      final donations = await _firestoreDatabase.fetchAllDonations();
      return donations.fold<double>(
        0.0,
            (sum, donation) => sum + donation.amount,
      );
    } catch (e) {
      print('Error calculating total donations: $e');
      return 0.0;
    }
  }

  static Future<void> updateBeneficiaryBudget(String id, double allocatedBudget) async {
    try {
      await _firestore.collection('beneficiaries').doc(id).update({
        'allocatedBudget': allocatedBudget,
      });
    } catch (e) {
      print('Error updating beneficiary budget: $e');
    }
  }

  static Future<void> updateTotalBudget(double totalBudget) async {
    try {
      await _firestore.collection('settings').doc('budget').set({
        'totalBudget': totalBudget,
      });
      print('Total budget updated successfully in Firebase.');
    } catch (e) {
      print('Failed to update total budget: $e');
    }
  }

  static Future<void> updateBeneficiaryAllocation(String id, double addedAmount) async {
    try {
      final doc = await _firestore.collection('beneficiaries').doc(id).get();
      if (doc.exists) {
        double currentAllocation = doc.data()?['allocatedBudget'] ?? 0.0;
        await _firestore.collection('beneficiaries').doc(id).update({
          'allocatedBudget': currentAllocation + addedAmount,
        });
      }
    } catch (e) {
      throw Exception('Failed to update allocation for beneficiary $id: $e');
    }
  }
}
