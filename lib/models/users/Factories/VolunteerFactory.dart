import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/Factories/userFactory.dart';
import 'package:hope_home/models/users/volunteer.dart';

class VolunteerFactory implements UserFactory {
  @override
  myUser createUser(Map<String, dynamic> userData) {
    return Volunteer(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      skills: List<String>.from(userData['skills'] ?? []),
      availability: List<String>.from(userData['availability'] ?? []),
      history: List<String>.from(userData['history'] ?? []),
    );
  }
}