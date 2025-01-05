import 'package:flutter/material.dart';
import '../../models/donation.dart';
import '../../models/FireStore.dart';

class DonationHistoryPage extends StatelessWidget {
  final String donorEmail;

  const DonationHistoryPage({Key? key, required this.donorEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<List<Donation>>(
        future: _dbService.fetchDonationsByEmail(donorEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No donations found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final donation = snapshot.data![index];
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
                          const Icon(Icons.volunteer_activism, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            donation.donorName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.attach_money, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                '\$${donation.amount.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.payment, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                donation.method,
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            donation.date,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
