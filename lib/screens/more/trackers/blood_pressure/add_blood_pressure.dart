import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_pressure/blood_pressure_tracker_screen.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/health_tracker.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';
import '../../../../widgets/app_default.dart';

class AddBloodPressureScreen extends StatefulWidget {
  @override
  _AddBloodPressureScreenState createState() => _AddBloodPressureScreenState();
}

class _AddBloodPressureScreenState extends State<AddBloodPressureScreen> {
  final _trackerKey = GlobalKey<FormState>();
  TextEditingController diastolic, notes, systolic, pulse;
  BloodPressureTracker bloodPressureTracker;

  @override
  void initState() {
    bloodPressureTracker = BloodPressureTracker();
    diastolic = TextEditingController(text: '');
    systolic = TextEditingController(text: '');
    pulse = TextEditingController(text: '');
    notes = TextEditingController(text: '');
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Text(
                  'Add Blood Pressure Data',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
              key: _trackerKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: diastolic,
                      decoration: InputDecoration(
                        hintText: 'Diastolic in mm/Hg',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      onChanged: (v) {
                        _trackerKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter value';
                        } else {
                          if (!isNumeric(value)) {
                            return 'Enter numeric value';
                          }

                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: systolic,
                      decoration: InputDecoration(
                        hintText: 'Systolic in mm/hg',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      onChanged: (v) {
                        _trackerKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter value';
                        } else {
                          if (!isNumeric(value)) {
                            return 'Enter numeric value';
                          }

                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: pulse,
                      decoration: InputDecoration(
                        hintText: 'Pulse in bpm',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      onChanged: (v) {
                        _trackerKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter value';
                        } else {
                          if (!isNumeric(value)) {
                            return 'Enter numeric value';
                          }

                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      onChanged: (v) {
                        _trackerKey.currentState.validate();
                      },
                      controller: notes,
                      decoration: InputDecoration(
                        hintText: 'Notes about Blood Pressure ',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter value';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      _trackerKey.currentState.validate();
                      await saveData();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BloodPressureTrackerScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        primary: Color(0xffff9987),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Text("Add Data",
                        style: TextStyle(fontFamily: 'Mulish', fontSize: 18)),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrackerHome()),
                      );
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Mulish',
                          //fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      primary: Color(0xffff9987),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.redAccent[100],
                          )),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  )
                ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(''),
            )
          ],
        ),
      ),
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  saveData() async {
    bloodPressureTracker.bloodPressure = BloodPressure(
        diastolic: int.parse(diastolic.text),
        systolic: int.parse(systolic.text),
        pulse: int.parse(pulse.text),
        notes: notes.text,
        dateTime: DateTime.now());
    /*await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('blood_pressure')
        .add(bloodPressureTracker.toMap());*/
  }

  getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
  }

  String userId;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}
