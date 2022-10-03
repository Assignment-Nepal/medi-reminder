import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:roro_medicine_reminder/firebase_options.dart';
import 'package:roro_medicine_reminder/resources/service_locator.dart';
import 'package:roro_medicine_reminder/screens/authenticate/signin.dart';
import 'package:roro_medicine_reminder/screens/document/add_documents_screen.dart';
import 'package:roro_medicine_reminder/screens/document/view_documents_screen.dart';
import 'package:roro_medicine_reminder/screens/hospital/nearby_hospital_screen.dart';
import 'package:roro_medicine_reminder/screens/main/home/JagaMe/contact_relatives_screen.dart';
import 'package:roro_medicine_reminder/screens/main/home/JagaMe/edit_relatives.dart';
import 'package:roro_medicine_reminder/screens/main/home/homePage.dart';
import 'package:roro_medicine_reminder/screens/main/home/initial_setup_screen.dart';
import 'package:roro_medicine_reminder/screens/main/home/profile/profile_edit_screen.dart';
import 'package:roro_medicine_reminder/screens/main/home/profile/profile_screen.dart';
import 'package:roro_medicine_reminder/screens/more/Refills/inventory.dart';
import 'package:roro_medicine_reminder/screens/main/progress.dart';
import 'package:roro_medicine_reminder/screens/more/notes/note_page.dart';
import 'package:roro_medicine_reminder/screens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:roro_medicine_reminder/screens/reminder/appoinment_reminder/appoinment_decision_screen.dart';
import 'package:roro_medicine_reminder/screens/reminder/appoinment_reminder/appoinment_detail_screen.dart';
import 'package:roro_medicine_reminder/screens/reminder/appoinment_reminder/appoinment_reminder_screen.dart';
import 'package:roro_medicine_reminder/screens/reminder/medicine/medicine_reminder.dart';
import 'package:roro_medicine_reminder/screens/reminder/medicine/reminder_detail.dart';
import 'package:roro_medicine_reminder/services/auth.dart';

import 'package:roro_medicine_reminder/services/notifications.dart';

import 'models/appoinment.dart';
import 'models/reminder.dart';

Future<void> main() async {
  setupLocator();
  FlutterDownloader.initialize(debug: false);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var fsconnect = FirebaseFirestore.instance;

  myget() async {
    var d = await fsconnect.collection("students").get();
    // print(d.docs[0].data());

    for (var i in d.docs) {
      print(i.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    Reminder reminder;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthClass(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationService(),
        ),
        StreamProvider<User>.value(
          value: FirebaseAuth.instance.authStateChanges(),
        ),
      ],
      child: Consumer<AuthClass>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'RORO',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:
          // HomePage(),
          auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (context, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? OnboardingScreen()
                          : OnboardingScreen()),
          routes: {
            Progress.routeName: (ctx) => Progress(),
            Inventory.routeName: (ctx) => Inventory(),
            SignInPage.routeName: (ctx) => SignInPage(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            ProfileEdit.routeName: (ctx) => ProfileEdit(),
            AddDocuments.routeName: (ctx) => AddDocuments(),
            ViewDocuments.routeName: (context) => ViewDocuments(),
            AppoinmentReminder.routeName: (ctx) => AppoinmentReminder(),
            AppoinmentDetail.routeName: (ctx) => AppoinmentDetail(
                  Appoinment('', '', '', '', 999999, false),
                  '',
                ),
            AppoinmentDecision.routeName: (context) =>
                AppoinmentDecision(Appoinment('', '', '', '', 999999, false)),
            MedicineReminder.routeName: (ctx) => MedicineReminder(),
            ContactScreen.routeName: (ctx) => ContactScreen(),
            NotePage.routeName: (ctx) => NotePage(),
            ReminderDetail.routeName: (ctx) => ReminderDetail(reminder, ''),
            NearbyHospitalScreen.routeName: (ctx) => NearbyHospitalScreen(),
            InitialSetupScreen.routeName: (ctx) => InitialSetupScreen(),
            EditRelativesScreen.routeName: (ctx) => EditRelativesScreen(''),
          },
        ),
      ),
    );
  }
}
