import 'package:flutter/material.dart';
import '../volunteer/Vol_login.dart';
import '../donor/signdonner.dart';
import '../donor/donor_login_screen.dart';
import '../volunteer/signvol.dart';
import '../admin/admin_sign_up_screen.dart';
import '../admin/admin_login_screen.dart';
import '../../controllers/signupController.dart';
import '../../controllers/loginController.dart';
import '../../models/users/userHelper.dart';
import '../../models/auth/FireAuth.dart';
import '../../models/db_handlers/FireStore.dart';
import '../../userProvider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 50),

            // Header
            const Center(
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            const Center(
              child: Text(
                'Choose your role to begin your journey!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // Buttons
            _buildOptionButton(
              context: context,
              title: 'Sign Up as Donor',
              icon: Icons.volunteer_activism,
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
              icon: Icons.group,
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
              icon: Icons.admin_panel_settings,
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
              icon: Icons.login,
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
              icon: Icons.person,
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
              icon: Icons.people,
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
    required IconData icon,
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
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        label: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
