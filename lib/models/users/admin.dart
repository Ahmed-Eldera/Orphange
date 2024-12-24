

import 'package:hope_home/models/user.dart';
import '../event.dart';
class Admin extends User {
  // String department;

  Admin({required String id, required String name,required String phone})
      : super(id: id, name: name,phone: phone);
Event createEvent(){
  // print("Event Created");
  Event fund=Event(attendance: 15,date: "feb",description: "456",id: "6",name: "atyam");
  return fund;
}
void editEvent(){
  print("Event edited");
}
void deleteEvent(){
  print("Event deleted");
}
void assignTask(){
  print("Task assiged");
}
void confirmCompletion(){
  print("Task Completed");
}

}
