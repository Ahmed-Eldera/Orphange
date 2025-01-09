import 'package:flutter/material.dart';
import 'package:hope_home/controllers/loginController.dart';
import 'package:hope_home/views/admin/admin_dashboard.dart';
import 'package:hope_home/views/volunteer/volunteerDashboard.dart';
import 'package:hope_home/views/general_auth/sign.dart';
import 'package:hope_home/views/donor/donner%20dashboard.dart';
import 'package:hope_home/userProvider.dart';
import 'custbutom.dart';
import 'textform.dart';

class Login extends StatefulWidget {
  final UserLoginMailController loginController;

  const Login({Key? key, required this.loginController}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> handleLogin() async {
    String emailText = email.text.trim();
    String passwordText = password.text.trim();

    if (emailText.isEmpty || passwordText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Get the user type after authentication
      String? userType = await widget.loginController.authenticate(
        emailText,
        passwordText,
      );

      if (userType != null) {
        widget.loginController.postLoginProcess();

        // Navigate based on user type
        if (userType == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VolunteerDashboard()),
          );
        } else if (userType == 'volunteer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VolunteerDashboard()),
          );
        } else if (userType == 'donor') {
          //Navigator.pushReplacement(
            //context,
            //MaterialPageRoute(builder: (context) => DonorDashboard()),
          //);
        } else {
          // Handle case where userType is not recognized
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown user type')),
          );
        }
      } else {
        // Handle case where userType is null (e.g., invalid email or password)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Welcome to Hope Home",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Login",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextForm(
              hinttext: "Enter your email",
              mycontroller: email,
            ),
            const SizedBox(height: 20),
            CustomTextForm(
              hinttext: "Enter your password",
              mycontroller: password,
            ),
            const SizedBox(height: 20),
            CustomButtonAuth(
              title: "Login",
              onPressed: handleLogin,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
