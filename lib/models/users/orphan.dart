

import 'package:hope_home/models/user.dart';


class Orphan extends User {
  String age;
  String needs;
  Orphan({required String id,
   required String name,
    required String phone,
     required this.age,
      required this.needs })
      : super(id: id, name: name, phone: phone,);
}

