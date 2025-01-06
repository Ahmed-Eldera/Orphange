// entertainment_share.dart

import 'decorator.dart';
import 'donation_calculator.dart';
import 'basic_donation.dart';

class EntertainmentShare extends DonationDecorator {
  final int quantity;

  EntertainmentShare(DonationCalculator donation, this.quantity) : super(donation);

  @override
  double getCost() {
    return super.getCost() + (50 * quantity);
  }

  @override
  String getDescription() {
    return '${super.getDescription()}, Entertainment x$quantity';
  }
}
