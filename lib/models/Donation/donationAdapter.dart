import 'package:hope_home/models/Donation/donation.dart';

class DonationAdapter {
  Donation donation ;
  DonationAdapter(this.donation);
  Map<String,dynamic> ToFireStore(){

    return {
      'id': donation.id,
      'donorName': donation.donorName,
      'donorEmail': donation.donorEmail,
      'amount': donation.amount,
      'method': donation.method,
      'date': donation.date,
    };


  }
}