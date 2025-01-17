import '../beneficiary.dart';

abstract class DistributionStrategy {
  Map<String, double> allocateBudget(double totalBudget, List<Beneficiary> beneficiaries);
}
