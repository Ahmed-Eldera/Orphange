import 'package:flutter/material.dart';
import '../volunteer/Vol_login.dart';
import '../donor/signdonner.dart';
import '../donor/donor_login_screen.dart';
import '../volunteer/signvol.dart';
import '../admin/admin_sign_up_screen.dart';
import '../admin/admin_login_screen.dart';
import '../../controllers/signupController.dart';
import '../../controllers/loginController.dart';

class SignUpScreen extends StatelessWidget {
  final UserSignupMailController _signupController = UserSignupMailController.createInstance();
  final UserLoginMailController _loginController = UserLoginMailController.createInstance();


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

            // Buttons for Sign Up and Login
            _buildOptionButton(
              context: context,
              title: 'Sign Up as Donor',
              icon: Icons.volunteer_activism,
              color: Colors.blue,
              onPressed: () => _navigateToDonorSignUp(context),
            ),
            _buildOptionButton(
              context: context,
              title: 'Sign Up as Volunteer',
              icon: Icons.group,
              color: Colors.orange,
              onPressed: () => _navigateToVolunteerSignUp(context),
            ),
            _buildOptionButton(
              context: context,
              title: 'Sign Up as Admin',
              icon: Icons.admin_panel_settings,
              color: Colors.red,
              onPressed: () => _navigateToAdminSignUp(context),
            ),
            _buildOptionButton(
              context: context,
              title: 'Login as Admin',
              icon: Icons.login,
              color: Colors.teal,
              onPressed: () => _navigateToAdminLogin(context),
            ),
            _buildOptionButton(
              context: context,
              title: 'Login as Donor',
              icon: Icons.person,
              color: Colors.purple,
              onPressed: () => _navigateToDonorLogin(context),
            ),
            _buildOptionButton(
              context: context,
              title: 'Login as Volunteer',
              icon: Icons.people,
              color: Colors.deepPurple,
              onPressed: () => _navigateToVolunteerLogin(context),
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

  // Navigation Functions
  void _navigateToDonorSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonorSignUpScreen(controller: _signupController),
      ),
    );
  }

  void _navigateToVolunteerSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VolunteerSignUpScreen(controller: _signupController),
      ),
    );
  }

  void _navigateToAdminSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminSignUpScreen(controller: _signupController),
      ),
    );
  }

  void _navigateToAdminLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminLoginScreen(controller: _loginController),
      ),
    );
  }

  void _navigateToDonorLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonorLoginScreen(controller: _loginController),
      ),
    );
  }

  void _navigateToVolunteerLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VolunteerLoginScreen(controller: _loginController),
      ),
    );
  }
}
