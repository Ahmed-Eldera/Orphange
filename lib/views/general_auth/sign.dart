import 'package:flutter/material.dart';
import 'package:hope_home/views/volunteer/Vol_login.dart';
import '../../controllers/signupController.dart';
import '../../models/users/userHelper.dart';
import '../donor/donor_login_screen.dart';
import '../donor/signdonner.dart';
import '../volunteer/signvol.dart';
import '../admin/admin_sign_up_screen.dart';
import '../admin/admin_login_screen.dart';
import '../../controllers/loginController.dart';
import '../../models/auth/FireAuth.dart';
import '../../models/db_handlers/FireStore.dart';
import '../../userProvider.dart';

void main() {
  runApp(MaterialApp(
    home: SignUpScreen(),
  ));
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 50),

            // Title Text
            const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle Text
            const Center(
              child: Text(
                'Choose an option to get started',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Button List
            _buildOptionButton(
              context: context,
              title: 'Sign Up as Donor',
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonorSignUpScreen(
                      controller: UserSignupMailController(
                        facade: UserServiceHelper(
                          authService: FirebaseAuthService(),
                          databaseService: FirestoreDatabaseService(),
                        ),
                        userProvider: UserProvider(),
                      ),
                    ),
                  ),
                );
              },
            ),

            _buildOptionButton(
              context: context,
              title: 'Sign Up as Volunteer',
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VolunteerSignUpScreen(
                      controller: UserSignupMailController(
                        facade: UserServiceHelper(
                          authService: FirebaseAuthService(),
                          databaseService: FirestoreDatabaseService(),
                        ),
                        userProvider: UserProvider(),
                      ),
                    ),
                  ),
                );
              },
            ),

            _buildOptionButton(
              context: context,
              title: 'Sign Up as Admin',
              color: Colors.red,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSignUpScreen(
                      controller: UserSignupMailController(
                        facade: UserServiceHelper(
                          authService: FirebaseAuthService(),
                          databaseService: FirestoreDatabaseService(),
                        ),
                        userProvider: UserProvider(),
                      ),
                    ),
                  ),
                );
              },
            ),

            _buildOptionButton(
              context: context,
              title: 'Login as Admin',
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminLoginScreen(
                      controller: UserLoginMailController(
                        userProvider: UserProvider(),
                        facade: UserServiceHelper(
                          authService: FirebaseAuthService(),
                          databaseService: FirestoreDatabaseService(),
                        ),
                        firestoreService: FirestoreDatabaseService(),
                      ),
                    ),
                  ),
                );
              },
            ),

            _buildOptionButton(
              context: context,
              title: 'Login as Donor',
              color: Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonorLoginScreen(
                      controller: UserLoginMailController(
                        userProvider: UserProvider(),
                        facade: UserServiceHelper(
                          authService: FirebaseAuthService(),
                          databaseService: FirestoreDatabaseService(),
                        ),
                        firestoreService: FirestoreDatabaseService(),
                      ),
                    ),
                  ),
                );
              },
            ),

            _buildOptionButton(
              context: context,
              title: 'Login as Volunteer',
              color: Colors.deepPurple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VolunteerLoginScreen(
                      controller: UserLoginMailController(
                        userProvider: UserProvider(),
                        facade: UserServiceHelper(
                          authService: FirebaseAuthService(),
                          databaseService: FirestoreDatabaseService(),
                        ),
                        firestoreService: FirestoreDatabaseService(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
