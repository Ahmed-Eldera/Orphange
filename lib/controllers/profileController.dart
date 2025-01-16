import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/Event/event.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/Factories/userFactory.dart';
import 'package:hope_home/userProvider.dart';

class Profilecontroller {
  myUser editUser(String name,myUser currentUser) {
    UserFactory userFactory = UserFactoryProducer.getFactory('Donor');
    Map<String,dynamic> data = {
      "name": name,
      "id": currentUser!.id,
      "email": currentUser!.email,
      "type": currentUser!.type
      };
       myUser user = userFactory!.createUser(data!);
       return user;
  }
  Future<void> updateuser(String name,myUser currentUser)async {
    myUser newuser = editUser(name, currentUser);
    UserProvider userProvider = UserProvider();
    await newuser.updateInfo();
    userProvider.setUser(newuser);
  }

}
