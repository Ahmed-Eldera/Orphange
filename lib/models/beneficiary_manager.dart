import 'beneficiary.dart';
import 'distribution_states/distribution_strategy.dart';

class BeneficiaryManager {
  late DistributionStrategy _strategy;

  BeneficiaryManager(this._strategy);

  void setStrategy(DistributionStrategy strategy) {
    _strategy = strategy;
  }

  Map<String, double> allocate(double budget, List<Beneficiary> beneficiaries) {
    return _strategy.allocateBudget(budget, beneficiaries);
  }
  DistributionStrategy getStrategy() {
    return _strategy;
  }
}
