import 'package:flutter/material.dart';
import 'package:hope_home/controllers/donation_controller.dart';
import 'package:hope_home/models/user.dart'; // The controller

class MakeDonationPage extends StatefulWidget {
  final myUser donor;

  const MakeDonationPage({Key? key, required this.donor}) : super(key: key);

  @override
  State<MakeDonationPage> createState() => _MakeDonationPageState();
}

class _MakeDonationPageState extends State<MakeDonationPage> {
  final _amountController = TextEditingController();
  String? _selectedMethod;
  DonationController _controller = DonationController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Donation'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Base Donation Amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (_) => setState(() {
                _controller.updateDonationAmount(double.tryParse(_amountController.text) ?? 0);
              }),
            ),
            const SizedBox(height: 16),
            _buildShareSelector('Healthcare', _controller.healthcareShares, 200, (newValue) {
              setState(() {
                _controller.updateHealthcareShares(newValue);
              });
            }),
            _buildShareSelector('School Supplies', _controller.schoolSuppliesShares, 200, (newValue) {
              setState(() {
                _controller.updateSchoolSuppliesShares(newValue);
              });
            }),
            _buildShareSelector('Entertainment', _controller.entertainmentShares, 50, (newValue) {
              setState(() {
                _controller.updateEntertainmentShares(newValue);
              });
            }),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Payment Method',
                prefixIcon: const Icon(Icons.payment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ['Visa', 'Cash', 'Bank Transfer', 'PayPal']
                  .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value;
                });
                _controller.updatePaymentMethod(value!);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Total Donation: \$${_controller.getTotalAmount().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_controller.getTotalAmount() > 0 && _selectedMethod != null) {
                  await _controller.submitDonation(widget.donor.name, widget.donor.email);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Donation submitted successfully!')));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit Donation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareSelector(String title, int count, int price, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$title (\$$price/share)', style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.red),
              onPressed: () => onChanged(count > 0 ? count - 1 : 0),
            ),
            Text('$count', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () => onChanged(count + 1),
            ),
          ],
        ),
      ],
    );
  }
}
