import 'beneficiary.dart';
import 'distribution_strategy.dart';

class ManualDistributionStrategy implements DistributionStrategy {
  @override
  Map<String, double> allocateBudget(double totalBudget, List<Beneficiary> beneficiaries) {
    double initialBudget = totalBudget * 0.5; // 50% of the total budget
    double remainingBudget = totalBudget * 0.5; // Remaining 50% for admin-controlled allocation

    Map<String, double> allocation = {};

    // Step 1: Distribute 50% equally
    double equalShare = initialBudget / beneficiaries.length;
    for (var beneficiary in beneficiaries) {
      allocation[beneficiary.id] = equalShare;
    }

    // Step 2: Add manually controlled budgets
    for (var beneficiary in beneficiaries) {
      if (beneficiary.manualBudget != null) {
        allocation[beneficiary.id] = allocation[beneficiary.id]??0 + beneficiary.manualBudget!;
        remainingBudget -= beneficiary.manualBudget!;
      }
    }

    // Ensure remainingBudget is not negative
    if (remainingBudget < 0) {
      throw Exception('Admin allocated more than the remaining 50% of the budget!');
    }

    return allocation;
  }
}
