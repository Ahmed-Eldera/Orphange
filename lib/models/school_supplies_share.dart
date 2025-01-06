// school_supplies_share.dart

import 'decorator.dart';
import 'donation_calculator.dart';
import 'basic_donation.dart';

class SchoolSuppliesShare extends DonationDecorator {
  final int quantity;

  SchoolSuppliesShare(DonationCalculator donation, this.quantity) : super(donation);

  @override
  double getCost() {
    return super.getCost() + (200 * quantity);
  }

  @override
  String getDescription() {
    return '${super.getDescription()}, School Supplies x$quantity';
  }
}
