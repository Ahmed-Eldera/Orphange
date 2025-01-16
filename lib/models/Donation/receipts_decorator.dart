import 'donation.dart';

abstract class ReceiptComponent {
  String generateReceipt();
}

class BaseReceipt implements ReceiptComponent {
  @override
  String generateReceipt() {
    return "Thank you for your support!";
  }
}

class DonationListDecorator extends ReceiptComponent {
  final ReceiptComponent receipt;
  final List<Donation> donations;

  DonationListDecorator(this.receipt, this.donations);

  @override
  String generateReceipt() {
    String donationDetails = donations
        .map((donation) =>
    "${donation.date}: ${donation.donorName} donated \$${donation.amount.toStringAsFixed(2)}")
        .join("\n");
    return "${receipt.generateReceipt()}\n\nDonation List:\n$donationDetails";
  }
}

class TotalDonationsDecorator extends ReceiptComponent {
  final ReceiptComponent receipt;
  final double total;

  TotalDonationsDecorator(this.receipt, this.total);

  @override
  String generateReceipt() {
    return "${receipt.generateReceipt()}\n\nTotal Donations: \$${total.toStringAsFixed(2)}";
  }
}

class NoTaxNoteDecorator extends ReceiptComponent {
  final ReceiptComponent receipt;

  NoTaxNoteDecorator(this.receipt);

  @override
  String generateReceipt() {
    return "${receipt.generateReceipt()}\n\nNote: No taxes applied to donations.";
  }
}
