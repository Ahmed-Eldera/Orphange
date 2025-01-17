import '../beneficiary.dart';
import 'distribution_strategy.dart';

class ManualDistributionStrategy implements DistributionStrategy {
  double totalAllocated = 0.0; // Track total allocated funds
  double _remainingBudget = 0.0; // Track remaining budget for manual allocation

  double get remainingBudget => _remainingBudget;
  @override
  Map<String, double> allocateBudget(double totalBudget, List<Beneficiary> beneficiaries) {
    double initialBudget = totalBudget * 0.5; // 50% for equal distribution
    totalAllocated = initialBudget; // Track allocated funds

    Map<String, double> allocation = {};

    // Step 1: Distribute 50% equally
    double equalShare = initialBudget / beneficiaries.length;
    for (var beneficiary in beneficiaries) {
      allocation[beneficiary.id] = equalShare;
    }

    return allocation;
  }

  double getRemainingBudget(double totalBudget) {
    return totalBudget - totalAllocated; // Calculate remaining budget dynamically
  }

  Map<String, double> allocateAddedFunds(double additionalFunds, double totalBudget, List<Beneficiary> beneficiaries) {
    double remainingBudget = getRemainingBudget(totalBudget);

    if (additionalFunds > remainingBudget) {
      throw Exception('Added funds exceed the remaining budget.');
    }

    Map<String, double> additionalAllocation = {};
    double sharePerChild = additionalFunds / beneficiaries.length;

    for (var beneficiary in beneficiaries) {
      additionalAllocation[beneficiary.id] = sharePerChild;
    }

    totalAllocated += additionalFunds; // Update allocated funds
    return additionalAllocation;
  }

  set remainingBudget(double value) {
    if (value < 0) {
      throw Exception('Remaining budget cannot be negative.');
    }
    _remainingBudget = value;
  }
}
