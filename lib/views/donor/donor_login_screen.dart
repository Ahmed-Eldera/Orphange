import 'package:flutter/material.dart';
import 'package:hope_home/controllers/loginController.dart';
import 'package:hope_home/views/donor/donner_dashboard.dart';

class DonorLoginScreen extends StatefulWidget {
  final UserLoginMailController controller;

  const DonorLoginScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _DonorLoginScreenState createState() => _DonorLoginScreenState();
}

class _DonorLoginScreenState extends State<DonorLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      String? userType = await widget.controller.login(email, password);

      if (userType == 'Donor') {
        // widget.controller.postLoginProcess();
        // var donor = widget.controller.userProvider.currentUser;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DonorDashboard(
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid donor credentials')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Login'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Donor Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: _handleLogin,
              child:  Text('Login',style:TextStyle(color:Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
