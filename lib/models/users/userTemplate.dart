import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/Factories/userFactory.dart';
import 'package:hope_home/models/users/userHelper.dart';


abstract class UserLoginTemplate {
    final UserServiceHelper facade;
    UserLoginTemplate({required this.facade});
    myUser? user;
    UserFactory? userFactory ;
  // The template method that outlines the steps
  Future<String?>  login(String email,String password,[String? name,String? type]) async {
    String? id = await authenticate(email,password,name??"",type??'');
    print(id);
    Map<String,dynamic> data = await fetchUserData(id) as Map<String,dynamic>;
    print(data);
    user = createUserObject(data);
    print(user);
    postLoginProcess(user);
    return data['type'];
  }

  // Step 1: Authentication (could be handled in Firebase)
  Future<String?> authenticate(String email,String password,[String? name,String? type]);

  // Step 2: Fetching user data from the DB (Firestore)

  Future<Map<String, dynamic>?> fetchUserData(id) async{
    return facade.fetchUserData(id);
  }




  myUser? createUserObject(Map<String,dynamic>? data) {
    userFactory = UserFactoryProducer.getFactory(data!['type']);
    user = userFactory!.createUser(data!);
    return user;
  }


  void postLoginProcess(myUser? user) {
  }
}