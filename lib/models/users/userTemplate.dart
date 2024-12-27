import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/userFactory.dart';
import 'package:hope_home/models/users/userHelper.dart';


abstract class UserLoginTemplate {
    myUser? user;
  // The template method that outlines the steps
  Future<void>  login(String email,String password,[String? name,String? type]) async {
    String? id = await authenticate(email,password);
    Map<String,dynamic> data = await fetchUserData(id) as Map<String,dynamic>;
    user = createUserObject(data);
    postLoginProcess();
  }

  // Step 1: Authentication (could be handled in Firebase)
  Future<String?> authenticate(String email,String password,[String? name,String? type]);

  // Step 2: Fetching user data from the DB (Firestore)

  Future<Map<String, dynamic>?> fetchUserData(id) async{
    return UserServiceHelper.fetchUserData(id);
  }




  myUser? createUserObject(Map<String,dynamic>? data) {
    // Use the factory to create the appropriate user object
    user = UserFactory.createUser(data!);
    return user;
  }


  void postLoginProcess() {
  }
}