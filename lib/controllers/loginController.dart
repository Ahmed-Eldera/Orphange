import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';

class UserLoginController extends UserLoginTemplate {
  final UserProvider userProvider;

  UserLoginController(this.userProvider);

  @override
  Future<String?> authenticate(String email,String password,[String? name,String? type]) async{
    return UserServiceHelper.loginWithEmailPassword(email, password);
  }

  @override
  void postLoginProcess() {
    // Any additional steps after login, like navigating to a specific page
    userProvider.setUser(user);
  }
}