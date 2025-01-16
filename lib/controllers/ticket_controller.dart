import '../models/db_handlers/FireStore.dart';
import '../models/ticket.dart';

class TicketController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();



  Future<void> registerTicket(Ticket ticket) async {
    try {
      await ticket.saveToFirestore();
    } catch (error) {
      throw Exception('Failed to register ticket: $error');
    }
  }
  Stream<List<Ticket>> getTicketsStream() {
    return _dbService.fetchTicketsStream().map((ticketDataList) {
      return ticketDataList.map((data) => Ticket.fromMap(data)).toList();
    });
  }

}
