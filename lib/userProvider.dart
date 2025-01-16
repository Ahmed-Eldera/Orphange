import 'package:flutter/foundation.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/Factories/userFactory.dart';

class UserProvider extends ChangeNotifier {
  // Singleton instance
  static final UserProvider _instance = UserProvider._internal();

  // Private constructor
  UserProvider._internal();

  // Public getter to access the singleton instance
  factory UserProvider() {
    return _instance;
  }

  // Current user
  myUser? _currentUser;

  myUser? get currentUser => _currentUser;

  // Set the current user and notify listeners
  void setUser(myUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  void display() {
    print(_currentUser!.name + "\n" + _currentUser!.type);
  }

  // Optionally, clear the user data on logout
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
  void editName(String name) {
    UserFactory userFactory = UserFactoryProducer.getFactory('Donor');
    Map<String,dynamic> data = {
      "name": name,
      "id": currentUser!.id,
      "email": currentUser!.email,
      "type": currentUser!.type};
       myUser user = userFactory!.createUser(data!);
       setUser(user);
       display();
  }
}
