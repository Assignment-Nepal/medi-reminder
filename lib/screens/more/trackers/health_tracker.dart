import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_pressure/add_blood_pressure.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_pressure/blood_pressure_tracker_screen.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/sleep/add_sleep_screen.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/sleep/sleep_tracker_screen.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/weight/add_weight.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/weight/weight_tracker_screen.dart';

import '../../../components/navBar.dart';
import '../../../widgets/app_default.dart';
import 'blood_sugar/add_blood_sugar.dart';
import 'blood_sugar/blood_sugar_tracker_screen.dart';

class TrackerHome extends StatefulWidget {
  const TrackerHome({Key key}) : super(key: key);

  @override
  State<TrackerHome> createState() => _TrackerHomeState();
}

class _TrackerHomeState extends State<TrackerHome> {
  Map<String, bool> hideMap, trackMap;

  initializeDisplayMap() {
    hideMap = Map<String, bool>();
    trackMap = Map<String, bool>();
    hideMap = {'sleep': true, 'weight': true, 'sugar': true, 'pressure': true};
    trackMap = {
      'sleep': false,
      'weight': true,
      'sugar': true,
      'pressure': true
    };
  }

  onHide(String type) {
    setState(() {
      hideMap[type] = false;
    });
  }

  @override
  void initState() {
    initializeDisplayMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: Text(
                'Health Trackers',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TrackerCard(
            title: 'Sleep Tracker',
            subTitle:
                'How Long did you sleep last night ?\nTrack hours slept to understand sleep patterns.',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddSleepScreen();
              }));
            },
            onHide: () => onHide('sleep'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SleepTrackerScreen();
              }));
            },
            isHidden: hideMap['sleep'],
            isTracking: true,
          ),
          TrackerCard(
            title: 'Weight Tracker',
            subTitle:
                '\nHow much did you weigh ? Track to see progress over time.\n',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddWeightScreen();
              }));
            },
            onHide: () => onHide('weight'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return WeightTrackerScreen();
              }));
            },
            isHidden: hideMap['weight'],
            isTracking: trackMap['weight'],
          ),
          TrackerCard(
            title: 'Blood Glucose',
            subTitle:
                '\nWhat\'s your blood sugar level ? Track to chart progress.\n',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddBloodSugarScreen();
              }));
            },
            onHide: () => onHide('sugar'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return BloodSugarTrackerScreen();
              }));
            },
            isHidden: hideMap['sugar'],
            isTracking: trackMap['sugar'],
          ),
          TrackerCard(
            title: 'Blood Pressure',
            subTitle:
                '\nWhat\'s your blood pressure reading ?Track to see progress over time.\n',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return AddBloodPressureScreen();
              }));
            },
            onHide: () => onHide('pressure'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return BloodPressureTrackerScreen();
              }));
            },
            isHidden: hideMap['pressure'],
            isTracking: trackMap['pressure'],
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}

class TrackerCard extends StatelessWidget {
  final String title, subTitle;
  final onHide, onAdd, onView;
  final bool isTracking, isHidden;

  TrackerCard(
      {this.title,
      this.isHidden,
      this.onAdd,
      this.onHide,
      this.subTitle,
      this.onView,
      this.isTracking});

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return Card(
        elevation: 2,
        color: Colors.grey.shade50,
        margin: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 3.3,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      /*FaIcon(
                        FontAwesomeIcons.poll,
                        color: Color(0xff3d5afe),
                      ),*/
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  subTitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isTracking
                      ? ElevatedButton(
                          onPressed: onView,
                          child: Text(
                            'View Chart',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
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
                                horizontal: 40, vertical: 10),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: onHide,
                          child: Text(
                            'Hide',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
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
                                horizontal: 40, vertical: 10),
                          ),
                        ),
                  SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      primary: Color(0xffff9987),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.redAccent[100],
                          )),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: Text("Add Data",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
