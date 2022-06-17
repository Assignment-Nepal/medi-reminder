

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/navBar.dart';
import '../../services/auth.dart';
import '../../widgets/app_default.dart';
import '../more/trackers/health_tracker.dart';
import '../reminder/measurement/measurement_screen.dart';
import '../reminder/medicine/medicine_reminder.dart';
import 'fab_menu.dart';

class Treatment extends StatefulWidget {
  Treatment({Key key}) : super(key: key);

  @override
  _TreatmentState createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: ROROAppBar(),
      body: Center(
        child: Container(
          child: Text("Add your treatments here!"),
        ),
      ),

      floatingActionButton: ExpandableFab(
        distance: 60.0,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MeasureScreen()),
              );
            },
            icon: const Icon(Icons.monitor_heart_sharp, color: Colors.blueGrey),
          ),
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MedicineReminder()),
              );
            },
            icon: const Icon(Icons.medication_liquid_outlined, color: Colors.blueGrey),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}