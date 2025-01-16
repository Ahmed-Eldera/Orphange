import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/models/users/userTemplate.dart';
import 'package:hope_home/userProvider.dart';
import '../models/db_handlers/FireStore.dart';
import '../models/auth/FireAuth.dart';

class UserSignupMailController extends UserLoginTemplate {
  final UserProvider userProvider;

  UserSignupMailController({
    required this.userProvider,
    required super.facade,
  });

  static UserSignupMailController createInstance() {
    return UserSignupMailController(
      facade: UserServiceHelper(
        authService: FirebaseAuthService(),
        databaseService: FirestoreDatabaseService(),
      ),
      userProvider: UserProvider(),
    );
  }

  @override
  Future<String?> authenticate(String email, String password, [String? name, String? type]) async {
    return facade.signupWithEmailPassword(email, password, name!, type!);
  }

  @override
  void postLoginProcess(myUser? user) {
    // Perform additional actions after login, like displaying user data
userProvider.setUser(user);
  }


}
