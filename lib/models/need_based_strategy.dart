import 'beneficiary.dart';
import 'distribution_strategy.dart';

class NeedBasedDistributionStrategy implements DistributionStrategy {
  @override
  Map<String, double> allocateBudget(double totalBudget, List<Beneficiary> beneficiaries) {
    double remainingBudget = totalBudget * 0.7; // 70% of total budget
    Map<String, double> allocation = {};

    // Calculate total weight based on age
    int totalWeight = beneficiaries.fold(0, (sum, child) => sum + child.age);

    for (var child in beneficiaries) {
      // Allocate budget proportional to age
      double allocationPerChild = (child.age / totalWeight) * remainingBudget;
      allocationPerChild = allocationPerChild > 500 ? 500 : allocationPerChild; // Cap at $500
      allocation[child.id] = allocationPerChild;
    }

    return allocation;
  }
}
