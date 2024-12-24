import 'package:flutter/material.dart';
import 'package:hope_home/views/login.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Volunteer Name and Role
            Center(
              child: Column(
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Volunteer',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Editable Information
            Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildEditableField(context, 'Email', 'johndoe@example.com'),
            _buildEditableField(context, 'Phone', '+123456789'),

            // Available Time Slot
            Text(
              'Available Time',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // Action for editing available time
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Monday: 9:00 AM - 5:00 PM\nWednesday: 10:00 AM - 2:00 PM\nFriday: 1:00 PM - 6:00 PM',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    Icon(Icons.edit, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Skills Section
            Text(
              'Skills',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // Action for editing skills
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Teamwork, Communication, Problem-Solving, Time Management',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    Icon(Icons.edit, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),

            Spacer(),

            // Buttons Section
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Edit Profile Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Edit Profile'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to Login page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Logout'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // A helper method for building editable fields
  Widget _buildEditableField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            // Show dialog or navigate to edit screen
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Icon(Icons.edit, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
