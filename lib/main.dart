import 'package:flutter/material.dart';
import 'package:hope_home/controllers/loginController.dart';
import 'package:hope_home/controllers/signupController.dart';
import 'package:hope_home/models/FireAuth.dart';
import 'package:hope_home/models/FireStore.dart';
import 'package:hope_home/models/users/userHelper.dart';
import 'package:hope_home/userProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseAuthService fireAuth= FirebaseAuthService();
  FirestoreDatabaseService firestore=FirestoreDatabaseService(); 
  UserServiceHelper facade = UserServiceHelper(authService:  fireAuth,databaseService:  firestore);
  UserProvider pro = UserProvider();
  UserSignupMailController controller = UserSignupMailController(userProvider:  pro,facade: facade);
  await controller.login("bzy@zbx.com","asdfasdf","ahmed","Volunteer");
  pro.display();
}
