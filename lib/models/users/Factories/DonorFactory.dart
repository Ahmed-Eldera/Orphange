import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/Factories/userFactory.dart';
import 'package:hope_home/models/users/donor.dart';

class DonorFactory implements UserFactory {
  @override
  myUser createUser(Map<String, dynamic> userData) {
    return Donor(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      history: List<String>.from(userData['history'] ?? []),
    );
  }
}