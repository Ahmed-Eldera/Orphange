import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';

import '../models/db_handlers/FireStore.dart';

class UserSignupMailController extends UserLoginTemplate {
  final UserProvider userProvider;
  UserSignupMailController({required  this.userProvider, required super.facade});
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  @override
  Future<String?> authenticate(String email,String password,[String? name,String? type]) async{
    return facade.signupWithEmailPassword(email, password,name!,type!);
  }

  @override
  void postLoginProcess() {
    // Any additional steps after login, like navigating to a specific page
    userProvider.setUser(user);
  }
  Future<void> signUpAdmin(String name, String email, String password) async {
    try {
      await _dbService.insertUser(
        DateTime.now().millisecondsSinceEpoch.toString(),
        name,
        email,
        'Admin',
      );
      // Add additional logic if needed, e.g., sending a welcome email.
    } catch (e) {
      throw Exception('Error signing up admin: $e');
    }
  }
}