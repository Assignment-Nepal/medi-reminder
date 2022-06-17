import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../components/navBar.dart';
import '../../../services/notifications.dart';
import '../../../widgets/home_screen_widgets.dart';
import '../../more/trackers/blood_pressure/blood_pressure_tracker_screen.dart';
import '../../more/trackers/blood_sugar/blood_sugar_tracker_screen.dart';
import '../../more/trackers/sleep/sleep_tracker_screen.dart';
import '../../more/trackers/weight/weight_tracker_screen.dart';


class MeasureScreen extends StatefulWidget {
  const MeasureScreen({Key key}) : super(key: key);

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  NotificationService notificationService;

  //AuthClass authClass = AuthClass();

  final auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    notificationService = NotificationService();
    notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ROROAppBar(),
        drawer: AppDrawer(),
        body: WillPopScope(
            onWillPop: () async {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RichAlertDialog(
                      alertTitle: richTitle("Exit the App"),
                      alertSubtitle: richSubtitle('Are you Sure '),
                      alertType: RichAlertType.WARNING,
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text("Yes"),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              splashColor: Colors.pink,
                              child: CardButton(
                                height: height * 0.2,
                                width: width * (35 / 100),
                                icon: FontAwesomeIcons.heartPulse,
                                size: width * (25 / 100),
                                color: Colors.pink[200],
                                borderColor: Colors.pink.withOpacity(0.75),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BloodPressureTrackerScreen()),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text('Blood pressure'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              splashColor: Colors.teal,
                              child: CardButton(
                                height: height * (20 / 100),
                                width: width * (35 / 100),
                                icon: Icons.bloodtype_outlined,
                                size: width * 0.2,
                                color: Colors.teal[300],
                                borderColor: Colors.teal.withOpacity(0.75),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BloodSugarTrackerScreen()),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text('Blood Sugar'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              splashColor: Colors.deepOrange,
                              child: CardButton(
                                height: height * (20 / 100),
                                width: width * (35 / 100),
                                icon: FontAwesomeIcons.bedPulse,
                                size: width * (25 / 100),
                                color: Colors.deepOrange[200],
                                borderColor: Colors.deepOrange.withOpacity(0.75),
                              ),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SleepTrackerScreen()),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Sleep',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              splashColor: Colors.cyan,
                              child: CardButton(
                                height: height * (20 / 100),
                                width: width * (35 / 100),
                                icon: Icons.scale,
                                size: width * 0.2,
                                color: Colors.cyan[600],
                                borderColor: Colors.cyan.withOpacity(0.75),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WeightTrackerScreen()),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text('Weight'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
//
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
}
