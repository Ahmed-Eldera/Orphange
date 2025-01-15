import 'package:flutter/material.dart';
import 'package:hope_home/controllers/loginController.dart';
import 'package:hope_home/models/auth/FireAuth.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/userProvider.dart';
import 'package:hope_home/views/general_auth/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'views/welcoming_screen.dart';
//hey youuuuu welcome to new world
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuthService fireAuth = FirebaseAuthService();
  FirestoreDatabaseService firestore = FirestoreDatabaseService();
  UserServiceHelper facade = UserServiceHelper(
    authService: fireAuth,
    databaseService: firestore,
  );
  UserProvider userProvider = UserProvider();
  UserLoginMailController loginController = UserLoginMailController(
    userProvider: userProvider,
    facade: facade,
    firestoreService: firestore,
  );

  runApp(MyApp(loginController: loginController));
}

class MyApp extends StatelessWidget {
  final UserLoginMailController loginController;

  const MyApp({Key? key, required this.loginController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hope Home',
      home:  WelcomingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
