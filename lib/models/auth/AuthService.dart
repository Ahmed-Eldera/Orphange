abstract class AuthService {
  Future<String?> login(String email, String password);
  Future<String?> signup(String email, String password, String name, String type);
}
