import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/ticket.dart';


class AdminTicketsPage extends StatelessWidget {
  const AdminTicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Tickets'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tickets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tickets available.'));
          }

          final tickets = snapshot.data!.docs.map((doc) {
            return Ticket.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.confirmation_number, color: Colors.blue), // Icon for the ticket
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${ticket.userName}\n',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.blue, // Name color
                          ),
                        ),
                        TextSpan(
                          text: ticket.eventName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.green, // Event name color
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16.0, color: Colors.grey),
                          const SizedBox(width: 4.0),
                          Text('Date: ${ticket.date}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.label, size: 16.0, color: Colors.grey),
                          const SizedBox(width: 4.0),
                          Text('ID: ${ticket.id}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.local_offer, size: 16.0, color: Colors.grey),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              'Donations: ${ticket.donationTypes.join(', ')}',
                              overflow: TextOverflow.ellipsis,
                            ),
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
