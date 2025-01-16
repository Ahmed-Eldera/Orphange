import 'package:flutter/material.dart';
import '../../controllers/donation_controller.dart';
import '../../models/Donation/donation.dart';
import '../../models/Donation/receipts_decorator.dart';
class ReceiptPage extends StatefulWidget {
  final String donorEmail;

  const ReceiptPage({Key? key, required this.donorEmail}) : super(key: key);

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final DonationController _controller = DonationController();
  bool includeAppreciation = true;
  bool includeDonationList = false;
  bool includeTotal = false;
  bool includeNoTaxNote = false;

  String receipt = "";

  Future<void> generateReceipt() async {
    ReceiptComponent receiptComponent = BaseReceipt();

    if (includeDonationList) {
      List<Donation> donations = await _controller.getDonationsForReceipt(widget.donorEmail);
      receiptComponent = DonationListDecorator(receiptComponent, donations);
    }
    if (includeTotal) {
      double total = await _controller.getTotalDonationsForReceipt(widget.donorEmail);
      receiptComponent = TotalDonationsDecorator(receiptComponent, total);
    }
    if (includeNoTaxNote) {
      receiptComponent = NoTaxNoteDecorator(receiptComponent);
    }

    setState(() {
      receipt = receiptComponent.generateReceipt();
    });
  }

  Widget _buildReceiptSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.blue.shade300, thickness: 2),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Receipt'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generate Receipt',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Donor Email: ${widget.donorEmail}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Options Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text("Include Appreciation Note"),
                      value: includeAppreciation,
                      onChanged: (value) => setState(() => includeAppreciation = value!),
                    ),
                    CheckboxListTile(
                      title: const Text("Include Donation List"),
                      value: includeDonationList,
                      onChanged: (value) => setState(() => includeDonationList = value!),
                    ),
                    CheckboxListTile(
                      title: const Text("Include Total Donations"),
                      value: includeTotal,
                      onChanged: (value) => setState(() => includeTotal = value!),
                    ),
                    CheckboxListTile(
                      title: const Text("Include No Tax Note"),
                      value: includeNoTaxNote,
                      onChanged: (value) => setState(() => includeNoTaxNote = value!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Generate Receipt Button
            Center(
              child: ElevatedButton(
                onPressed: generateReceipt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Generate Receipt",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Receipt Display
            if (receipt.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: receipt.split('\n\n').map((section) {
                    final lines = section.split('\n');
                    return _buildReceiptSection(lines.first, lines.sublist(1).join('\n'));
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
