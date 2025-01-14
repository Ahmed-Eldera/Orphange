import 'package:hope_home/controllers/communication_context.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import '../models/users/donor.dart';

class DonorController {
  // CommunicationContext _context = CommunicationContext();
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  // Future<void>? notifyUsers(){print("");}
  Future<List<Donor>> getAllDonors() async {
    return await _dbService.fetchAllDonors();
  }

}
