import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';

class UserLoginMailController extends UserLoginTemplate {
  final UserProvider userProvider;
  // final UserServiceHelper facade;
    UserLoginMailController({required this.userProvider, required super.facade});

  @override
  Future<String?> authenticate(String email,String password,[String? name,String? type]) async{
    return facade.loginWithEmailPassword(email, password);
  }

  @override
  void postLoginProcess() {
    // Any additional steps after login, like navigating to a specific page
    userProvider.setUser(user);
  }
}