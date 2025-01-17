import 'package:hope_home/models/Donation/donation.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/admin.dart';
import 'package:hope_home/userProvider.dart';
import '../models/users/donor.dart';

class DonorController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  myUser user = UserProvider().currentUser!;
  Future<List<Donor>> getAllDonors() async {
    if (user is! Admin) {
      throw Exception('Only admin can fetch all donors');     
    }else{
    return await (user as Admin).fetchAllDonors();
  }
  }
  Future<List<Donor>> fetchDonors() async {
    if (user is! Admin) {
      throw Exception('Only admin can fetch all donors');     
    }else{

    return await (user as Admin).fetchAllDonors();
  }}

  Future<Map<String, double>> fetchDonorTotals() async {
    try {
      final List<Donation> donations = await (UserProvider().currentUser! as Admin).fetchAllDonations();
      Map<String, double> donorTotals = {};

      for (var donation in donations) {
        donorTotals[donation.donorEmail] =
            (donorTotals[donation.donorEmail] ?? 0) + donation.amount;
      }
      return donorTotals;
    } catch (e) {
      print('Error fetching total donations by donor: $e');
      return {};
    }
  }
}
