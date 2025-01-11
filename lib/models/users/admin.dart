import 'package:hope_home/models/user.dart';

class Admin extends myUser {
  Admin({
    required super.id,
    required super.name,
    required super.email
    })
    : super(type: 'Admin');

  void manageUsers() {
    print('Managing userss...');
  }
}