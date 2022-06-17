import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_pressure/chart_widget.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';

class BloodPressureTrackerScreen extends StatefulWidget {
  @override
  _BloodPressureTrackerScreenState createState() =>
      _BloodPressureTrackerScreenState();
}

class _BloodPressureTrackerScreenState
    extends State<BloodPressureTrackerScreen> {
  getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
  }

  QuerySnapshot snapshot;
  String userId;
  double averageDiastolic, averageSystolic, averagePulse;
  BloodPressureTracker bloodPressure;
  getDocumentList() async {
    bloodPressure = BloodPressureTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('blood_pressure')
        .get();
    averageDiastolic = 0;
    double totalDiastolic = 0, totalSystolic = 0, totalPulse = 0;

    List<BloodPressure> list = bloodPressure.loadData(snapshot);
    for (var s in list) {
      totalDiastolic += s.diastolic;
      totalSystolic += s.systolic;
      totalPulse += s.pulse;
    }

    setState(() { averageDiastolic = totalDiastolic / list.length;
    averageSystolic = totalSystolic / list.length;
    averagePulse = totalPulse / list.length;});

    return snapshot;
  }

  PageController _controller;

  @override
  void initState() {
    getCurrentUser();
    _controller = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Diastolic ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                      children: <Widget>[ Container(
                          margin: EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.docs.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'diastolic',
                              ),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ]),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Diastolic '),
                          title: Text(averageDiastolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              }),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Systolic',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ListView(
                          shrinkWrap: true,
                      children: <Widget>[ Container(
                          margin: EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.docs.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'systolic',
                              ),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ]),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Systolic'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              }),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Pulse',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                      children: <Widget>[ Container(
                          margin: EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.docs.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'pulse',
                              ),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ]),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Pulse'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              })
        ],
      ),
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
