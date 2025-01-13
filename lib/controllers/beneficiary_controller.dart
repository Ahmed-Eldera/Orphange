import '../models/db_handlers/FireStore.dart';

class BeneficiaryController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  Future<double> getTotalBudget() async {
    return await _dbService.getTotalDonations();
  }

  Future<void> saveAllocatedBudget(Map<String, double> allocations) async {
    try {
      for (var entry in allocations.entries) {
        await _dbService.updateBeneficiaryBudget(entry.key, entry.value);
      }
    } catch (e) {
      print('Error saving allocated budgets: $e');
    }
  }
}
