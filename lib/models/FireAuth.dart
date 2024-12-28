import 'package:firebase_auth/firebase_auth.dart';
import 'package:hope_home/models/AuthService.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }

  @override
  Future<String?> signup(String email, String password, String name, String type) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } catch (e) {
      print('Signup failed: $e');
      return null;
    }
  }
}
