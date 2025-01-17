import '../beneficiary.dart';
import 'distribution_strategy.dart';

class EqualDistributionStrategy implements DistributionStrategy {
  @override
  Map<String, double> allocateBudget(double totalBudget, List<Beneficiary> beneficiaries) {
    double perChild = totalBudget * 0.7 / beneficiaries.length;
    perChild = perChild > 500 ? 500 : perChild; // Cap at $500
    return {for (var child in beneficiaries) child.id: perChild};
  }
}
