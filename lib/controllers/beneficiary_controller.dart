import '../models/beneficiary.dart';
import '../models/db_handlers/FireStore.dart';
import '../models/manual_distribution_strategy.dart';

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
  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    try {
      await _dbService.addBeneficiary(beneficiary);
    } catch (e) {
      print('Error adding beneficiary: $e');
    }
  }

  Future<void> updateBeneficiary(Beneficiary beneficiary) async {
    try {
      await _dbService.updateBeneficiary(beneficiary);
    } catch (e) {
      print('Error updating beneficiary: $e');
    }
  }
  Future<void> updateAllocation(String beneficiaryId, double allocation) async {
    try {
      await _dbService.updateBeneficiaryBudget(beneficiaryId, allocation);
    } catch (e) {
      print('Error updating allocation: $e');
    }
  }
  Future<void> addFunds(double additionalFunds, double totalBudget,
      List<Beneficiary> beneficiaries, ManualDistributionStrategy strategy) async {
    try {
      double remainingBudget = strategy.getRemainingBudget(totalBudget);

      if (additionalFunds > remainingBudget) {
        throw Exception(
            'Added funds exceed the remaining budget of \$${remainingBudget.toStringAsFixed(2)}.');
      }

      final additionalAllocation =
      strategy.allocateAddedFunds(additionalFunds, totalBudget, beneficiaries);

      for (var entry in additionalAllocation.entries) {
        await _dbService.updateBeneficiaryAllocation(entry.key, entry.value);
      }
    } catch (e) {
      throw Exception('Error adding funds: $e');
    }
  }
  Future<List<Beneficiary>> fetchBeneficiaries() async {
    try {
      return await _dbService.fetchBeneficiaries();
    } catch (e) {
      print('Error fetching beneficiaries: $e');
      return [];
    }
  }
}
