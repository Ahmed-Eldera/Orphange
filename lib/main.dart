import 'package:flutter/material.dart';
import 'package:hope_home/controllers/loginController.dart';
import 'package:hope_home/userProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
  );
  UserProvider pro = UserProvider();
  UserLoginController controller = UserLoginController(pro);
  await controller.login("a@a.com","asdfasdf");
  pro.display();
}
