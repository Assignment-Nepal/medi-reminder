import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_sugar/chart_widget.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';

class BloodSugarTrackerScreen extends StatefulWidget {
  @override
  _BloodSugarTrackerScreenState createState() =>
      _BloodSugarTrackerScreenState();
}

class _BloodSugarTrackerScreenState extends State<BloodSugarTrackerScreen> {
  getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
  }

  QuerySnapshot snapshot;
  String userId;
  double averageValue;
  BloodSugarTracker bloodSugar;
  getDocumentList() async {
    bloodSugar = BloodSugarTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('blood_sugar')
        .get();
    averageValue = 0;
    double totalValue = 0;

    List<BloodSugar> list = bloodSugar.loadData(snapshot);
    for (var s in list) {
      totalValue += s.bloodSugar;
    }

    setState(() {  averageValue = totalValue / list.length;});

    return snapshot;
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                'Blood Sugar Tracker',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return
                      ListView(
                        shrinkWrap: true,
                        //scrollDirection: Axis.horizontal,
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
                              child: BloodSugarChart(
                                animate: true,
                                userID: userId,
                              ),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Blood Sugar'),
                          title: Text(averageValue.toStringAsFixed(2)),
                        ),
                      )]);
                } else
                  return SizedBox();
              }),
        ],
      )),
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
