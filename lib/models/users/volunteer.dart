

import 'package:hope_home/models/user.dart';

class Volunteer extends User {
  String age;
  String skills;
  bool availability;
  Volunteer({required String id,
   required String name,
    required String phone,

     required this.age,
      required this.skills,
       required this.availability })
  : super(id: id, name: name, phone: phone);

  void logHours(){
    print("Hours Logged");
  }
  void completeEvent(){
    print("Event is Completed");
  }
  void endLog(){
    print("Hours Ended");
  }
  void generateCertificate(){
    print("Certificate is Generated");
  }
}



