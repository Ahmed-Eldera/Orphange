import 'package:flutter/material.dart';
import '../../controllers/beneficiary_controller.dart';
import '../../models/beneficiary.dart';
import '../../models/beneficiary_manager.dart';
import '../../models/distribution_states/distribution_strategy.dart';
import '../../models/distribution_states/equal_distribution_strategy.dart';
import '../../models/distribution_states/manual_distribution_strategy.dart';
import '../../models/distribution_states/need_based_strategy.dart';
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
  final BeneficiaryController _controller = BeneficiaryController();
  @override
  void initState() {
    super.initState();
    _fetchTotalBudget();
    _loadInitialData();
  }
  void _fetchTotalBudget() async {
    double totalDonations = await _controller.getTotalBudget();
    setState(() {
      totalBudget = totalDonations;
    });
  }
  void _loadInitialData() async {
    totalBudget = await _controller.getTotalBudget();
    setState(() {
      _beneficiaries = _controller.fetchBeneficiaries();
    });
  }



  void _changeStrategy(DistributionStrategy strategy, String strategyName) async {
    if (_currentStrategy == strategyName) return;

    setState(() {
      _currentStrategy = strategyName;
    });

    await _controller.changeStrategy(strategy, totalBudget);
    setState(() {
      _beneficiaries = _controller.fetchBeneficiaries();
    });
  }



  void _addFunds() async {
    if (_currentStrategy != "Manual Distribution") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add Funds is only available in Manual Distribution strategy.')),
      );
      return;
    }

    final TextEditingController _fundController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              if (additionalFunds == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid amount')),
                );
                return;
              }

              try {
                await _controller.addFunds(
                  additionalFunds,
                  totalBudget,
                  await _beneficiaries,
                  _manager.getStrategy() as ManualDistributionStrategy,
                );
                setState(() {
                  _beneficiaries = _controller.fetchBeneficiaries();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funds allocated successfully.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('Add Funds'),
          ),
        ],
      ),
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
          _loadInitialData();;
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
