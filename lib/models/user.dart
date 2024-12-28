class myUser {
  final String id;
  final String name;
  final String email;
  final String type;

  myUser({required this.id, required this.name, required this.email, required this.type});

  // Factory constructor to create a user from Firestore data
  factory myUser.fromFirestore(Map<String, dynamic> data) {
    return myUser(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      type: data['type'],
    );
  }
}
