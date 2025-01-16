import 'package:flutter/material.dart';
import '../../controllers/ticket_controller.dart';
import '../../models/ticket.dart';

class AdminTicketsPage extends StatelessWidget {
  final TicketController _ticketController = TicketController();

  AdminTicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Tickets'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: _ticketController.getTicketsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tickets available.'),
            );
          }

          final tickets = snapshot.data!;
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return _buildTicketCard(tickets[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const Icon(Icons.confirmation_number, color: Colors.blue),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${ticket.userName}\n',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.blue,
                ),
              ),
              TextSpan(
                text: ticket.eventName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(Icons.calendar_today, 'Date: ${ticket.date}'),
            _buildRow(Icons.label, 'ID: ${ticket.id}'),
            _buildRow(
              Icons.local_offer,
              'Donations: ${ticket.donationTypes.join(', ')}',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String text, {TextOverflow? overflow}) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: Colors.grey),
        const SizedBox(width: 4.0),
        Expanded(
          child: Text(
            text,
            overflow: overflow ?? TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
