import 'package:flutter/material.dart';
import '../../models/beneficiary.dart';
import '../../models/beneficiary_manager.dart';
import '../../models/db_handlers/FireStore.dart';
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
  final FirestoreDatabaseService _dbservice = FirestoreDatabaseService();
  final BeneficiaryManager _manager = BeneficiaryManager(ManualDistributionStrategy());
  double totalBudget = 700; // Example initial budget

  late Future<List<Beneficiary>> _beneficiaries;

  String _currentStrategy = "Manual Distribution"; // Current strategy

  @override
  void initState() {
    super.initState();
    _fetchBeneficiaries();
  }

  void _fetchBeneficiaries() {
    setState(() {
      _beneficiaries = _dbservice.fetchBeneficiaries();
    });
  }

  void _changeStrategy(DistributionStrategy strategy, String strategyName) {
    setState(() {
      _manager.setStrategy(strategy);
      _currentStrategy = strategyName;
    });
  }


  void _addFunds() {
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
              labelText: 'Enter Additional Budget (\$)',
              hintText: 'e.g., 5000',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double? additionalFunds = double.tryParse(_fundController.text);
                if (additionalFunds != null) {
                  setState(() {
                    totalBudget += additionalFunds;
                  });
                  Navigator.pop(context);
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

  void _updateManualBudget(Beneficiary beneficiary, double manualAddition) async {
    setState(() {
      beneficiary.manualBudget = manualAddition;
    });
    await _dbservice.updateBeneficiary(beneficiary);
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
                Map<String, double> allocations = _manager.allocate(totalBudget, beneficiaries);

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
                          'Base Allocation: \$${allocations[beneficiary.id]?.toStringAsFixed(2)}\n'
                              'Manual Adjustment: \$${beneficiary.manualBudget?.toStringAsFixed(2) ?? 'None'}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showManualBudgetDialog(context, beneficiary);
                          },
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
      onPressed: () => _changeStrategy(strategy, label),
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showManualBudgetDialog(BuildContext context, Beneficiary beneficiary) {
    final TextEditingController _manualBudgetController = TextEditingController(
      text: beneficiary.manualBudget?.toStringAsFixed(2) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adjust Budget for ${beneficiary.name}'),
          content: TextField(
            controller: _manualBudgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Manual Budget (\$)',
              hintText: 'Enter new budget amount',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double? newBudget = double.tryParse(_manualBudgetController.text);
                if (newBudget != null) {
                  _updateManualBudget(beneficiary, newBudget);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid budget amount')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
