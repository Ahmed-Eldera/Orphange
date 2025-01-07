
// Abstract Decorator
import 'donation_calculator.dart';

abstract class DonationDecorator implements DonationCalculator {
  final DonationCalculator donation;

  DonationDecorator(this.donation);

  @override
  double getCost() {
    return donation.getCost();
  }

  @override
  String getDescription() {
    return donation.getDescription();
  }
}

// Concrete Decorators
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
