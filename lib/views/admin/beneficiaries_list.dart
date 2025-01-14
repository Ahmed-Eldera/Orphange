import 'package:flutter/material.dart';
import '../../controllers/beneficiary_controller.dart';
import '../../models/beneficiary.dart';
import '../../models/beneficiary_manager.dart';
import '../../models/distribution_strategy.dart';
import '../../models/equal_distribution_strategy.dart';
import '../../models/need_based_strategy.dart';
import '../../models/manual_distribution_strategy.dart';
import 'add_edit_beneficiary.dart';

class BeneficiariesListPage extends StatefulWidget {
  const BeneficiariesListPage({Key? key}) : super(key: key);

  @override
  _BeneficiariesListPageState createState() => _BeneficiariesListPageState();
}

class _BeneficiariesListPageState extends State<BeneficiariesListPage> {

  final BeneficiaryManager _manager = BeneficiaryManager(ManualDistributionStrategy());
  double totalBudget = 700; // Example initial budget

  late Future<List<Beneficiary>> _beneficiaries;

  String _currentStrategy = "Manual Distribution"; // Current strategy

  @override
  void initState() {
    super.initState();
    _fetchTotalBudget();
    _fetchBeneficiaries();
  }
  void _fetchTotalBudget() async {
    double totalDonations = await BeneficiaryController().getTotalBudget();
    setState(() {
      totalBudget = totalDonations;
    });
  }
  void _fetchBeneficiaries() {
    setState(() {
      _beneficiaries = BeneficiaryController().fetchBeneficiaries();
    });
  }

  void _applyStrategy() {
    _beneficiaries.then((beneficiaries) {
      final allocations = _manager.allocate(totalBudget, beneficiaries);
      BeneficiaryController().saveAllocatedBudget(allocations);
    });
  }


  void _changeStrategy(DistributionStrategy strategy, String strategyName) {
    if (_currentStrategy == strategyName) return; // Avoid redundant updates

    setState(() {
      _manager.setStrategy(strategy); // Update the strategy in the manager
      _currentStrategy = strategyName; // Update the current strategy name

      // Reset remainingBudget if ManualDistributionStrategy
      if (strategy is ManualDistributionStrategy) {
        (strategy as ManualDistributionStrategy).remainingBudget = totalBudget * 0.5;
      }
    });

    // Recalculate and save allocations based on the new strategy
    _applyStrategy();

    // Refresh the screen by fetching beneficiaries
    _fetchBeneficiaries();
  }



  void _addFunds() {
    if (_currentStrategy != "Manual Distribution") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add Funds is only available in Manual Distribution strategy.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _fundController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Funds'),
          content: TextField(
            controller: _fundController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter Budget to Add (\$)',
              hintText: 'e.g., 1000',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                double? additionalFunds = double.tryParse(_fundController.text);
                if (additionalFunds != null) {
                  try {
                    ManualDistributionStrategy strategy =
                    _manager.getStrategy() as ManualDistributionStrategy;

                    List<Beneficiary> beneficiaries = await _beneficiaries;
                    await BeneficiaryController().addFunds(
                      additionalFunds,
                      totalBudget,
                      beneficiaries,
                      strategy,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Funds allocated successfully.')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid amount')),
                  );
                }
              },
              child: const Text('Add Funds'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Beneficiaries'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Budget: \$${totalBudget.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Current Strategy: $_currentStrategy',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStrategyButton('Equal Distribution', Icons.equalizer, EqualDistributionStrategy()),
                  const SizedBox(width: 16),
                  _buildStrategyButton('Need-Based Distribution', Icons.accessibility_new, NeedBasedDistributionStrategy()),
                  const SizedBox(width: 16),
                  _buildStrategyButton('Manual Distribution', Icons.edit, ManualDistributionStrategy()),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _addFunds,
              icon: const Icon(Icons.add),
              label: const Text('Add Funds to Budget'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Beneficiary>>(
              future: _beneficiaries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<Beneficiary> beneficiaries = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: beneficiaries.length,
                  itemBuilder: (context, index) {
                    Beneficiary beneficiary = beneficiaries[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('${beneficiary.name} (${beneficiary.age} years old)'),
                        subtitle: Text(
                          'Allocated Budget: \$${beneficiary.allocatedBudget.toStringAsFixed(2)}',
                        ),
                      ),
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditBeneficiaryPage(),
            ),
          );
          _fetchBeneficiaries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStrategyButton(String label, IconData icon, DistributionStrategy strategy) {
    return ElevatedButton.icon(
      onPressed: () => _confirmStrategySwitch(strategy, label),
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }


  void _confirmStrategySwitch(DistributionStrategy strategy, String strategyName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Strategy Switch'),
          content: const Text('Switching strategies will overwrite the allocated budget for all beneficiaries. Do you wish to continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog first
                _changeStrategy(strategy, strategyName); // Apply the strategy change and refresh
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }




}
