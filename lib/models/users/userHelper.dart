import 'package:hope_home/models/auth/AuthService.dart';
import 'package:hope_home/models/db_handlers/DBService.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';

class UserServiceHelper {
  final AuthService authService;
  final DatabaseService databaseService;  // This will now refer to the interface

  UserServiceHelper({
    required this.authService,
    required this.databaseService,
  });

  // Login method
  Future<String?> loginWithEmailPassword(String email, String password) async {
    return await authService.login(email, password);
  }

  // Signup method
  Future<String?> signupWithEmailPassword(String email, String password, String name, String type) async {
    String? userId = await authService.signup(email, password, name, type);
    if (userId != null) {
      await databaseService.insertUser(userId, name, email, type);
    }
    return userId;
  }

  // Fetch user data
  Future<Map<String, dynamic>?> fetchUserData(String id) async {
    return await databaseService.fetchUserData(id);
  }
}
