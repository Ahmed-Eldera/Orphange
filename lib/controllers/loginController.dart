import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/user.dart';

import '../models/auth/FireAuth.dart';

class UserLoginMailController extends UserLoginTemplate {
  final UserProvider userProvider;

  UserLoginMailController({
    required this.userProvider,
    required super.facade,

  });
  // ignore: empty_constructor_bodies
  static UserLoginMailController createInstance(){
    return UserLoginMailController(
      facade: UserServiceHelper(
        authService: FirebaseAuthService(),
        databaseService: FirestoreDatabaseService(),
      ),
      userProvider: UserProvider(),
    );
  }


  @override
  Future<String?> authenticate(String email, String password, [String? name, String? type]) async {
    try {
      String? userId = await facade.loginWithEmailPassword(email, password);

      if (userId != null) {
        var userData = await facade.fetchUserData(userId);
        if (userData != null) {
          String? userType = userData['type']?.toString(); // Force conversion to String

          if (userType == null || userType.isEmpty) {
            throw Exception('User type is missing or invalid.');
          }

          // Store user data in provider
          
          return userId;
        } else {
          throw Exception('User data not found.');
        }
      } else {
        throw Exception('User ID is null.');
      }
    } catch (e) {
      print('Error during authentication: $e');
      return null;
    }
  }




  @override
  void postLoginProcess(myUser? user) {
    // Perform additional actions after login, like displaying user data
userProvider.setUser(user);
  }
}