import 'package:hope_home/models/FireStore.dart';
import '../models/users/donor.dart';

class DonorController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  Future<List<Donor>> getAllDonors() async {
    return await _dbService.fetchAllDonors();
  }
}
