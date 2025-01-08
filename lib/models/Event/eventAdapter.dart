import 'package:hope_home/models/Event/event.dart';

class EventAdapter{
  Event event;
  EventAdapter(this.event);
  Map<String,dynamic> ToFireStore(){

    return {
      'name': event.name,
      'description': event.description,
      'date': event.date,
      'attendance': event.attendance,
    };
  
  }
}