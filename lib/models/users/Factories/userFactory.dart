import 'package:hope_home/models/user.dart';
import 'package:hope_home/models/users/Factories/AdminFactory.dart';
import 'package:hope_home/models/users/Factories/DonorFactory.dart';
import 'package:hope_home/models/users/Factories/VolunteerFactory.dart';



// Abstract Factory (UserFactory interface)
abstract class UserFactory {
  myUser createUser(Map<String, dynamic> userData);
}

class UserFactoryProducer {
  static UserFactory getFactory(String type) {
    switch (type) {
      case 'Admin':
        return AdminFactory();
      case 'Volunteer':
        return VolunteerFactory();
      case 'Donor':
        return DonorFactory();
      default:
        throw Exception('Unknown user type: $type');
    }
  }
}



