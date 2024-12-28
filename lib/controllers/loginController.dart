import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';
import 'package:hope_home/models/FireStore.dart';
import 'package:hope_home/models/users/userFactory.dart';// Ensure Firestore service is imported
import 'package:hope_home/models/user.dart';

class UserLoginMailController extends UserLoginTemplate {
  final UserProvider userProvider;
  final UserServiceHelper facade;
  final FirestoreDatabaseService firestoreService;

  UserLoginMailController({
    required this.userProvider,
    required this.facade,
    required this.firestoreService,
  }) : super(facade: facade); // Call the parent class constructor and pass required parameters

  @override
  Future<String?> authenticate(String email, String password, [String? name, String? type]) async {
    // Authenticate with Firebase Authentication
    String? userId = await facade.loginWithEmailPassword(email, password);

    if (userId != null) {
      // Fetch user data from Firestore
      var userData = await firestoreService.getUserById(userId);

      if (userData != null) {
        // Assume your Firestore document has a field 'type' to store user type (donor, admin, etc.)
        String userType = userData['type'];

        // Set the user in the UserProvider (using the user data from Firestore)
        userProvider.setUser(myUser.fromFirestore(userData));

        return userType;  // Return the user type (donor, admin, etc.)
      }
    }
    return null; // Return null if login failed or no user data found
  }

  @override
  void postLoginProcess() {
    // Perform additional actions after login, like displaying user data
    userProvider.display();
  }
}