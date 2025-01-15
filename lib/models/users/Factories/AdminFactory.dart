import 'package:hope_home/models/users/Factories/userFactory.dart';
import 'package:hope_home/models/users/admin.dart';
import 'package:hope_home/models/user.dart';

class AdminFactory implements UserFactory {
  @override
  myUser createUser(Map<String, dynamic> userData) {
    return Admin(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
    );
  }
}

