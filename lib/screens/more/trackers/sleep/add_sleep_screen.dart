import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/sleep/sleep_tracker_screen.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';
import '../health_tracker.dart';

class AddSleepScreen extends StatefulWidget {
  @override
  _AddSleepScreenState createState() => _AddSleepScreenState();
}

class _AddSleepScreenState extends State<AddSleepScreen> {
  final _trackerKey = GlobalKey<FormState>();
  TextEditingController hours, minutes, notes;
  SleepTracker sleepTracker;

  @override
  void initState() {
    sleepTracker = SleepTracker();

    hours = TextEditingController(text: '');
    notes = TextEditingController(text: '');
    minutes = TextEditingController(text: '');
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
                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Text(
                  'Add Sleep Data',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _trackerKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: hours,
                            decoration: InputDecoration(
                              hintText: 'Hours Slept',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                            ),
                            onChanged: (v) {
                              _trackerKey.currentState.validate();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter minutes';
                              } else {
                                if (!isNumeric(value)) {
                                  return 'Enter numeric value';
                                }
                                if (int.parse(value) < 0 ||
                                    int.parse(value) > 20) {
                                  return 'Enter Valid value';
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: minutes,
                            onChanged: (v) {
                              _trackerKey.currentState.validate();
                            },
                            decoration: InputDecoration(
                              hintText: 'Minutes Slept',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter minutes';
                              } else {
                                if (!isNumeric(value)) {
                                  return 'Enter numeric value';
                                }
                                if (int.parse(value) < 0 ||
                                    int.parse(value) >= 60) {
                                  return 'Enter valid values';
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
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
                        hintText: 'Notes about sleep ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
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
            ),Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  _trackerKey.currentState.validate();
                  await saveData();
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SleepTrackerScreen()));
                },
              style: ElevatedButton.styleFrom(elevation: 2,
                  primary: Color(0xffff9987),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child:
                  Text("Add Data", style: TextStyle(fontFamily:'Mulish', fontSize: 18)),

            ),SizedBox(
        width: 25,
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackerHome()),
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
          padding: EdgeInsets.symmetric(
              horizontal: 40, vertical: 15),
        ),
      )
    ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recommended sleep time is 8 hours.'),
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
    sleepTracker.sleepData = Sleep(
        hours: int.parse(hours.text),
        minutes: int.parse(minutes.text),
        notes: notes.text,
        dateTime: DateTime.now());
    await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('sleep')
        .add(sleepTracker.toMap());
  }

  getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
  }

  String userId;
}

//_registerFormKey.currentState.validate();

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}
