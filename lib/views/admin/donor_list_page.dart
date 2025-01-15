import 'package:flutter/material.dart';
import '../../controllers/donor_controller.dart';
import '../../models/users/donor.dart';

class DonorListPage extends StatefulWidget {
  const DonorListPage({Key? key}) : super(key: key);

  @override
  _DonorListPageState createState() => _DonorListPageState();
}

class _DonorListPageState extends State<DonorListPage> {
  Map<String, double> _donorTotals = {};
  List<Donor> _donors = [];
  bool _isLoading = true;
  final DonorController _controller = DonorController();

  @override
  void initState() {
    super.initState();
    _loadDonorsWithTotals();
  }

  Future<void> _loadDonorsWithTotals() async {
    setState(() {
      _isLoading = true;
    });

    final donors = await _controller.fetchDonors();
    final totals = await _controller.fetchDonorTotals();

    setState(() {
      _donors = donors;
      _donorTotals = totals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Donors'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_donors.isEmpty)
          ? const Center(
        child: Text(
          'No donors found.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _donors.length,
        itemBuilder: (context, index) {
          final donor = _donors[index];
          final totalDonations =
              _donorTotals[donor.email] ?? 0.0;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          donor.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Email: ${donor.email}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total Donations: \$${totalDonations.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
