// healthcare_share.dart

import 'decorator.dart';
import 'donation_calculator.dart';
import 'basic_donation.dart';

class HealthcareShare extends DonationDecorator {
  final int quantity;

  HealthcareShare(DonationCalculator donation, this.quantity) : super(donation);

  @override
  double getCost() {
    return super.getCost() + (200 * quantity);
  }

  @override
  String getDescription() {
    return '${super.getDescription()}, Healthcare x$quantity';
  }
}
