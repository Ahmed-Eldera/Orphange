import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/users/Factories/userFactory.dart';// Ensure Firestore service is imported
import 'package:hope_home/models/user.dart';

import '../models/auth/FireAuth.dart';

class UserLoginMailController extends UserLoginTemplate {
  final UserProvider userProvider;
  final UserServiceHelper facade;
  final FirestoreDatabaseService firestoreService;

  UserLoginMailController({
    required this.userProvider,
    required this.facade,
    required this.firestoreService,
  }) : super(facade: facade); // Call the parent class constructor and pass required parameters
  static UserLoginMailController createInstance() {
    return UserLoginMailController(
      facade: UserServiceHelper(
        authService: FirebaseAuthService(),
        databaseService: FirestoreDatabaseService(),
      ),
      userProvider: UserProvider(),
      firestoreService: FirestoreDatabaseService(),
    );
  }

  @override
  @override
  Future<String?> authenticate(String email, String password, [String? name, String? type]) async {
    try {
      String? userId = await facade.loginWithEmailPassword(email, password);

      if (userId != null) {
        var userData = await firestoreService.getUserById(userId);
        if (userData != null) {
          String? userType = userData['type']?.toString(); // Force conversion to String

          if (userType == null || userType.isEmpty) {
            throw Exception('User type is missing or invalid.');
          }

          // Store user data in provider
          userProvider.setUser(myUser.fromFirestore(userData));
          return userType;
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
  void postLoginProcess() {
    // Perform additional actions after login, like displaying user data
    userProvider.display();
  }
}