// donation_controller.dart

import 'package:hope_home/models/Donation/donationAdapter.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/Donation/basic_donation.dart'; // Import the BasicDonation
import 'package:hope_home/models/Donation/healthcare_share.dart'; // Import HealthcareShare decorator
import 'package:hope_home/models/Donation/school_supplies_share.dart'; // Import SchoolSuppliesShare decorator
import 'package:hope_home/models/Donation/entertainment_share.dart'; // Import EntertainmentShare decorator
import 'package:hope_home/models/Donation/donation.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/donor.dart';
import 'package:hope_home/userProvider.dart';

import '../models/Donation/donation_calculator.dart';
import '../models/Donation/receipts_decorator.dart';
import '../models/users/admin.dart'; // Import the Donation model


class DonationController {
  double baseAmount = 0;
  int healthcareShares = 0;
  int schoolSuppliesShares = 0;
  int entertainmentShares = 0;
  String paymentMethod = '';
  Donor user = UserProvider().currentUser! as Donor;

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
  Future<void> submitDonation() async {
    final totalAmount = getTotalAmount();
    if (UserProvider().currentUser is Donor) {
      Donor donor = UserProvider().currentUser as Donor;
      await donor.submitDonation(totalAmount, paymentMethod, DateTime.now().toIso8601String());
    }
  } 

  Future<List<Donation>> getDonationHistory(String donorEmail) async {
    return await user.fetchDonationsByEmail();
  }
  Future<List<Donation>> fetchDonations() async {
    try {
      // FirestoreDatabaseService _dbService = FirestoreDatabaseService();

      if (UserProvider().currentUser is Donor) {
        // If the user is a Donor, fetch donations specific to their email
        Donor donor = UserProvider().currentUser as Donor;
        return await donor.fetchDonationsByEmail();
      } else if (UserProvider().currentUser is Admin) {
        // If the user is an Admin, fetch all donations
        return await (UserProvider().currentUser! as Admin).fetchAllDonations();
      } else {
        throw Exception('Unsupported user type');
      }
    } catch (e) {
      print('Error fetching donations: $e');
      throw Exception('Failed to fetch donations');
    }
  }

  Future<List<Donation>> getDonationsForReceipt(String donorEmail) async {
    return await user.fetchDonationsByEmail();
  }

  Future<double> getTotalDonationsForReceipt(String donorEmail) async {
    List<Donation> donations = await getDonationsForReceipt(donorEmail);
    return donations.fold<double>(
      0.0, // Starting value for the sum
          (sum, donation) => sum + donation.amount, // Accumulator function
    );
  }
  Future<ReceiptComponent> generateReceipt({
    required String donorEmail,
    bool includeDonationList = false,
    bool includeTotal = false,
    bool includeNoTaxNote = false,
  }) async {
    ReceiptComponent receipt = BaseReceipt();

    if (includeDonationList) {
      List<Donation> donations = await getDonationsForReceipt(donorEmail);
      receipt = DonationListDecorator(receipt, donations);
    }

    if (includeTotal) {
      double total = await getTotalDonationsForReceipt(donorEmail);
      receipt = TotalDonationsDecorator(receipt, total);
    }

    if (includeNoTaxNote) {
      receipt = NoTaxNoteDecorator(receipt);
    }

    return receipt;
  }
}
