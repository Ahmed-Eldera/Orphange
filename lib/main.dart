import 'package:flutter/material.dart';
import 'package:hope_home/models/event.dart';
import 'package:hope_home/views/donor_dashboard.dart';
// import 'views/welcome_screen.dart';
import 'models/users/admin.dart';
import 'models/users/donor.dart';
import 'models/users/volunteer.dart';
import 'models/users/orphan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hope_home/views/sign.dart';
import 'package:hope_home/views/signvol.dart';
import 'package:hope_home/views/signdonner.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',  // Set initial route to SignUpScreen
      routes: {
        '/': (context) => SignUpScreen(),
        '/donorSignup': (context) => DonorSignUpScreen(),
        '/volunteerSignup': (context) => VolunteerSignUpScreen(),
        '/donorDashboard': (context) => DonorDashboard(),
      },
    );
  }
}
class FirestoreExample extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
    Admin ahmed = Admin(id: '1', name: "ahmed", phone: "0123");
    Volunteer vovo=Volunteer(id: "2", name: "mdo7aas", phone: "0123456", age: "15", skills: "PR", availability: true);
    Orphan batman=Orphan(id: "3", name: "bruce", phone: "1532", age: "45", needs: "softskills");
    Donor abohashima = Donor(id: "5",name: "malak",phone: "16562");
  void addUser() async {
    await firestore.collection('users').add({
      'name': 'John Doe',
      'age': 30,
    });
    print('User is added');
  }
   void addVolunteer(Volunteer vol) async {
    await firestore.collection('volunteers').doc(vol.id.toString()).set({
      'name': vol.name,
      'age': vol.age,
      'phone': vol.phone,
      'skills': vol.skills,
      'availability': vol.availability
    });
    print('Volunteers are added');
  }
   void addDonor(Donor donor) async {
    await firestore.collection('donors').doc(donor.id.toString()).set({
      'name': donor.name,
      'phone': donor.phone,
    });
    print('Donors are added');
    // Event? event= await donor.getEvent('5');
    // print(event?.name??'x');
    List<String>? names = await donor.getAllEventNames();
    print(names);
    Event? event = await donor.getEventByName('amwat');
    print(event?.date??'');
  }
  void addOrphan(Orphan orphan) async {
    await firestore.collection('orphans').doc(orphan.id.toString()).set({
      'name': orphan.name,
      'phone': orphan.phone,
      'age': orphan.age,
      'needs': orphan.needs,
    });
    print('Orphans are added');
  }
  void addAdmin(Admin admin) async{
    await firestore.collection('admins').doc(admin.id.toString()).set({
      'name': admin.name,
      'phone': admin.phone,
    });
    print('Admins are added');
    Event fund = admin.createEvent();
     addEvent(fund);
        print(fund.name);
      fund.generateTicket();
      print(fund.tickets![0].date);
  }
  void addEvent(Event event)async {
    await firestore.collection('events').doc(event.id.toString()).set({
      'name' : event.name,
      'attendance' :event.attendance,
      'description':event.description,
      'date' : event.date
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Example')),
      body: Center(
        child: Column(
          children: [
          
            ElevatedButton(
              onPressed:()=> addAdmin(ahmed),
              child: Text('Add admin'),
            ),
            ElevatedButton(
              onPressed:()=> addVolunteer(vovo),
              child: Text('Add orphan'),
            ),
            ElevatedButton(
              onPressed:()=> addOrphan(batman),
              child: Text('Add volunteer'),
            ),
            ElevatedButton(
              onPressed:()=> addDonor(abohashima),
              child: Text('Add donor'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrphanageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orphanage Management System',
      theme: ThemeData(
        // Using primarySwatch to define the primary color and generate shades.
        primarySwatch: Colors.blueGrey,
        // Defining a ColorScheme that handles more nuanced theming capabilities.
        colorScheme: ColorScheme.light(
          primary: Colors.blueGrey,
          onPrimary: Colors.white, // Text/icon color on top of the primary color.
          secondary: Colors.amber,
          onSecondary: Colors.black, // Text/icon color on top of the secondary color.
        ),
        // Ensuring all text styles are updated and accessible.
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        // Using ElevatedButton's default style to replace deprecated button themes.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueGrey, // Text color
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
void create(){

  // ahmed.createEvent();
}
class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Flutter App!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()=>create(),
              
              child: Text('Go to Second Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
