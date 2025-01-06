// basic_donation.dart

import 'donation_calculator.dart';

class BasicDonation implements DonationCalculator {
  final double baseAmount;

  BasicDonation(this.baseAmount);

  @override
  double getCost() {
    return baseAmount;
  }

  @override
  String getDescription() {
    return 'Basic Donation';
  }
}
