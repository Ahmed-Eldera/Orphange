import 'package:flutter/material.dart';
import '../../models/donation.dart';
import '../../models/FireStore.dart';

class MakeDonationPage extends StatefulWidget {
  final Map<String, dynamic> donor;

  const MakeDonationPage({Key? key, required this.donor}) : super(key: key);

  @override
  State<MakeDonationPage> createState() => _MakeDonationPageState();
}

class _MakeDonationPageState extends State<MakeDonationPage> {
  final _amountController = TextEditingController();
  String? _selectedMethod;
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  final List<String> _methods = ['Visa', 'Cash', 'Bank Transfer', 'PayPal'];

  void _submitDonation() async {
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || _selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final donation = Donation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      donorName: widget.donor['name'],
      donorEmail: widget.donor['email'],
      amount: amount,
      method: _selectedMethod!,
      date: DateTime.now().toIso8601String(),
    );

    try {
      await _dbService.addDonation(donation);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation submitted successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting donation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Donation'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Donation Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Donation Amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Donation Method',
                prefixIcon: const Icon(Icons.payment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _methods
                  .map((method) => DropdownMenuItem(
                value: method,
                child: Text(method),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value;
                });
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Donation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
