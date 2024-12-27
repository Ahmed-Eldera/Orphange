import 'package:hope_home/models/user.dart';

class Admin extends myUser {
  Admin({required String id, required String name, required String email})
      : super(id: id, name: name, email: email, type: 'Admin');

  void manageUsers() {
    print('Managing users...');
  }
}