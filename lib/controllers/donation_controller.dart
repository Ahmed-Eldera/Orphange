// donation_controller.dart

import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/Donation/basic_donation.dart'; // Import the BasicDonation
import 'package:hope_home/models/Donation/healthcare_share.dart'; // Import HealthcareShare decorator
import 'package:hope_home/models/Donation/school_supplies_share.dart'; // Import SchoolSuppliesShare decorator
import 'package:hope_home/models/Donation/entertainment_share.dart'; // Import EntertainmentShare decorator
import 'package:hope_home/models/Donation/donation.dart';

import '../models/Donation/donation_calculator.dart'; // Import the Donation model


class DonationController {
  double baseAmount = 0;
  int healthcareShares = 0;
  int schoolSuppliesShares = 0;
  int entertainmentShares = 0;
  String paymentMethod = '';

  // Get total amount
  double getTotalAmount() {
    // Start with the basic donation amount
    DonationCalculator calculator = BasicDonation(baseAmount);

    // Apply decorators if shares are selected
    if (healthcareShares > 0) {
      calculator = HealthcareShare(calculator, healthcareShares);  // Create instance of HealthcareShare
    }
    if (schoolSuppliesShares > 0) {
      calculator = SchoolSuppliesShare(calculator, schoolSuppliesShares);  // Create instance of SchoolSuppliesShare
    }
    if (entertainmentShares > 0) {
      calculator = EntertainmentShare(calculator, entertainmentShares);  // Create instance of EntertainmentShare
    }

    return calculator.getCost();  // Return the final total cost
  }

  // Update donation amount
  void updateDonationAmount(double amount) {
    baseAmount = amount;
  }

  // Update the number of shares
  void updateHealthcareShares(int quantity) {
    healthcareShares = quantity;
  }

  void updateSchoolSuppliesShares(int quantity) {
    schoolSuppliesShares = quantity;
  }

  void updateEntertainmentShares(int quantity) {
    entertainmentShares = quantity;
  }

  // Update the payment method
  void updatePaymentMethod(String method) {
    paymentMethod = method;
  }

  // Submit donation to Firestore
  Future<void> submitDonation(String donorName, String donorEmail) async {
    final totalAmount = getTotalAmount();
    final donation = Donation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      donorName: donorName,
      donorEmail: donorEmail,
      amount: totalAmount,
      method: paymentMethod,
      date: DateTime.now().toIso8601String(),
    );

    FirestoreDatabaseService _dbService = FirestoreDatabaseService();
    await _dbService.addDonation(donation);
  }
}
