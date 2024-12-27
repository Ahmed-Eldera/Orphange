import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';

class UserSignupController extends UserLoginTemplate {
  final UserProvider userProvider;

  UserSignupController(this.userProvider);

  @override
  Future<String?> authenticate(String email,String password,[String? name,String? type]) async{
    return UserServiceHelper.signupWithEmailPassword(email, password,name!,type!);
  }

  @override
  void postLoginProcess() {
    // Any additional steps after login, like navigating to a specific page
    userProvider.setUser(user);
  }
}