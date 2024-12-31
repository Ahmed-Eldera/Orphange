
// In your DBService.dart file:
abstract class DatabaseService {
  Future<void> insertUser(String id, String name, String email, String type);
  Future<Map<String, dynamic>?> fetchUserData(String id);
}
