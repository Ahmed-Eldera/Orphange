import 'package:hope_home/models/Donation/donation.dart';
import 'package:hope_home/models/users/admin.dart';
import 'package:hope_home/userProvider.dart';

import '../models/beneficiary.dart';
import '../models/db_handlers/FireStore.dart';
import '../models/distribution_states/distribution_strategy.dart';
import '../models/distribution_states/manual_distribution_strategy.dart';

class BeneficiaryController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  Future<double> getTotalBudget() async {
    try {
      // Fetch all donations
      final List<Donation> donations = await (UserProvider().currentUser! as Admin).fetchAllDonations();

      // Fold over the list to calculate the total
      return donations.fold<double>(0.0, (double sum, Donation donation) => sum + donation.amount);
    } catch (e) {
      print('Error calculating total donations: $e');
      return 0.0;
    }
  }

  Future<void> saveAllocatedBudget(Map<String, double> allocations) async {
    try {
      for (var entry in allocations.entries) {
        await Beneficiary.updateBeneficiaryBudget(entry.key, entry.value);
      }
    } catch (e) {
      print('Error saving allocated budgets: $e');
    }
  }
  Future<void> changeStrategy(DistributionStrategy strategy, double totalBudget) async {
    try {
      // Fetch beneficiaries
      List<Beneficiary> beneficiaries = await fetchBeneficiaries();

      // Allocate budget using the strategy
      final allocations = strategy.allocateBudget(totalBudget, beneficiaries);

      // Save the allocated budget
      await saveAllocatedBudget(allocations);
    } catch (e) {
      print('Error changing strategy: $e');
      throw Exception('Failed to change strategy');
    }
  }

  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    try {
      await Beneficiary.addBeneficiary(beneficiary);
    } catch (e) {
      print('Error adding beneficiary: $e');
    }
  }
  Future<void> deleteBeneficiary(String id) async {
    try {
      await Beneficiary.deleteBeneficiary(id);
    } catch (e) {
      print('Error deleting beneficiary: $e');
    }
  }
  Future<void> updateBeneficiary(Beneficiary beneficiary) async {
    try {
      await Beneficiary.updateBeneficiary(beneficiary);
    } catch (e) {
      print('Error updating beneficiary: $e');
      throw Exception('Failed to update beneficiary');
    }
  }



  Future<void> updateAllocation(String beneficiaryId, double allocation) async {
    try {
      await Beneficiary.updateBeneficiaryBudget(beneficiaryId, allocation);
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
        await Beneficiary.updateBeneficiaryAllocation(entry.key, entry.value);
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
