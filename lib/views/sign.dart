import 'package:flutter/material.dart';
import 'package:hope_home/views/volunteerDashboard.dart';
import '../controllers/loginController.dart';
import '../controllers/signupController.dart';
import '../models/FireAuth.dart';
import '../models/FireStore.dart';
import '../models/users/userHelper.dart';
import '../userProvider.dart';
import 'signdonner.dart';
import 'signvol.dart';
import 'admin_dashboard.dart';
import 'admin_sign_up_screen.dart'; // Import Admin Sign-Up
import 'admin_login_screen.dart'; // Import Admin Login

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
        child: ListView(
          children: [
            const SizedBox(height: 50),

            // Title Text
            const Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
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
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Sign Up as Donor Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonorSignUpScreen(),
                  ),
                );
              },
              child: const Text('Sign Up as Donor'),
            ),

            const SizedBox(height: 20),

            // Sign Up as Volunteer Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VolunteerSignUpScreen(),
                  ),
                );
              },
              child: const Text('Sign Up as Volunteer'),
            ),

            const SizedBox(height: 20),

            // Sign Up as Admin Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
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
              child: const Text('Sign Up as Admin'),
            ),

            const SizedBox(height: 20),

            // Login as Admin Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
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
              child: const Text('Login as Admin'),
            ),

            const SizedBox(height: 20),

            // Navigate to Dashboard Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(),
                  ),
                );
              },
              child: const Text('Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
