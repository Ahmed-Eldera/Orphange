

import 'package:hope_home/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../event.dart';


class Donor extends User {
  Donor ({required String id, required String name, required String phone,
   }) 
  : super(id: id, name: name, phone: phone,);
void donate(){
  print("Donated");
}
void genrateReciept(){
  print("Donated");
}void history(){
  print("Donated");
}
Future<List<String>> getAllEventNames() async {
  try {
    // Get all documents from the events collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('events')
        .get();

    // Extract event names from each document and return as a list
    List<String> eventNames = snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return data['name'] as String;
    }).toList();

    return eventNames;
  } catch (e) {
    print('Error fetching event names: $e');
    return [];
  }
}


Future<Event?> getEventByName(String eventName) async {
  try {
    // Query Firestore for the event where the name matches
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('name', isEqualTo: eventName) // Filter by event name
        .get();

    // Check if any document matches
    if (snapshot.docs.isNotEmpty) {
      // Extract data from the first matching document
      var data = snapshot.docs[0].data() as Map<String, dynamic>;

      // Create and return the Event object
      return Event(
        id: snapshot.docs[0].id,
        name: data['name'],
        attendance: data['attendance'],
        description: data['description'],
        date: data['date'],
        // Initialize tickets as empty or as per your logic
      );
    } else {
      print('Event not found');
      return null; // Return null if no event is found
    }
  } catch (e) {
    print('Error fetching event by name: $e');
    return null; // Return null if there's an error
  }
}

}
