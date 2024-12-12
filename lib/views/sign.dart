import 'package:flutter/material.dart';
import 'signdonner.dart';
import 'signvol.dart';
void main() {
  runApp(MaterialApp(
    home: SignUpScreen(),
  ));
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title Text
            Text(
              'Sign Up as',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Sign Up as Donor Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DonorSignUpScreen(), // Navigate to the donor sign-up screen
    ),
  );
              },
              child: Text('Sign Up as Donor'),
            ),
            SizedBox(height: 20),

            // Sign Up as Volunteer Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 90),
               
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VolunteerSignUpScreen(), // Navigate to the donor sign-up screen
    ),
  );
              },
              child: Text('Sign Up as Volunteer'),
            ),
          ],
        ),
      ),
    );
  }
}
