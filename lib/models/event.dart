import 'package:hope_home/models/ticket.dart';
class Event {
  String id;
  String name;
  int attendance;
  String description;
  String date;
  List<Ticket>? tickets ;

  Event({
    required this.id,
    required this.name,
    required this.attendance,
    required this.description,
    required this.date,
     // Optional parameter
  }): tickets = []; // Initialize tickets with an empty list if null

  Ticket generateTicket(){
    Ticket ticket=Ticket(id: "1", date:"march", userName: "mo", eventName: "jngfdjgk");
    tickets!.add(ticket);
    return ticket;
  }
}

