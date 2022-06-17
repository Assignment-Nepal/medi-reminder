
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:roro_medicine_reminder/screens/main/home/JagaMe/edit_relatives.dart';


import '../../../../components/navBar.dart';
import '../../../../models/elder_location.dart';
import '../../../../models/user.dart';
import '../../../../widgets/app_default.dart';



class ContactScreen extends StatefulWidget {
  static const String routeName = 'Contact_Screen';
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ElderLocation elderLocation;
  String messageText = '', username = 'user', userId;
  bool relativesFound = false;
  UserProfile userProfile;
  getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
  }

  getLocationDetails() async {
    await elderLocation.getLocationData();
    messageText =
        'Hey , This is $username find me at ${elderLocation.address} .\n Link to my location : ${elderLocation.url}';
    return elderLocation;
  }

  _sendSMS(String message, List<String> recipients) async {
    String _result = await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
      print(onError);
    });

    print(_result);
  }

  List<String> recipients;

  @override
  void initState() {
    super.initState();
    recipients = [];
    getCurrentUser();
    elderLocation = ElderLocation();

    getLocationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: ROROAppBar(),
        body: ListView(
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('profile')
                    .doc(userId)
                    .collection('relatives')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> relativesWidget = [];
                    recipients = [];
                    var data = snapshot.data.docs;
                    if (data != null) {
                      userProfile.getAllRelatives(data);
                      if (data.length > 0) relativesFound = true;
                      for (var relative in userProfile.relatives) {
                        recipients.add(relative.phoneNumber);
                        relativesWidget.add(RelativeDetail(
                          name: relative.name,
                          email: relative.email,
                          number: relative.phoneNumber,
                          documentID: relative.documentID,
                          userId: userId,
                        ));
                      }

                      relativesWidget.add(Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.group_add,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Add Relative',
                              style:
                              TextStyle(color: Colors.white, fontSize: 19),
                            ),
                            onPressed: () async {
                              Map<String, dynamic> dataMap = {
                                'name': '',
                                'email': '',
                                'phoneNumber': '',
                                'uid': ''
                              };
                              var ref = await FirebaseFirestore.instance
                                  .collection('profile')
                                  .doc(userId)
                                  .collection('relatives')
                                  .add(dataMap);

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditRelativesScreen(ref.id);
                              }));
                            },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xffff9987),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),

                          ))));
                      relativesWidget.add(SizedBox(
                        height: 10,
                      ));
                    } else {
                      relativesFound = false;
                      relativesWidget.add(Center(
                        child: Container(
                          decoration: BoxDecoration(),
                          margin: EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 12),
                                child: Text('No relatives added.'),
                              ),
                              ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.group_add,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Add Relative',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19)),
                                  onPressed: () async {
                                    Map<String, dynamic> dataMap = {
                                      'name': '',
                                      'email': '',
                                      'phoneNumber': '',
                                      'uid': ''
                                    };
                                    var ref = await FirebaseFirestore.instance
                                        .collection('profile')
                                        .doc(userId)
                                        .collection('relatives')
                                        .add(dataMap);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EditRelativesScreen(
                                          ref.id);
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xffff9987),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),

                                  ))
                            ],
                          ),
                        ),
                      ));
                    }

                    return Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                            child: Text(
                              'JagaMe Details',
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Mulish',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: relativesWidget,
                        ),
                        FutureBuilder(
                            future: getLocationDetails(),
                            builder: (context, future) {
                              if (future.hasData) {
                                ElderLocation _elderLocation = future.data;
                                if (_elderLocation == null || data.length == 0)
                                  return SizedBox();
                                return Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return RichAlertDialog(
                                              alertTitle:
                                                  richTitle("Alert Relatives"),
                                              alertSubtitle:
                                                  richSubtitle('Are you Sure '),
                                              alertType: RichAlertType.WARNING,
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("Yes"),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    if (relativesFound) {
                                                      _sendSMS(messageText,
                                                          recipients);
                                                      print(messageText);
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 55.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.redAccent[100],
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red[100],
                                            blurRadius: 3.0,
                                            offset: Offset(0, 4.0),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        'Contact Relatives',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                );
                              } else
                                return LinearProgressIndicator();
                            }),
                      ],
                    );
                  } else
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 50),
                      child: SpinKitWanderingCubes(
                        color: Colors.blueGrey,
                        size: 100.0,
                      ),
                    );
                }),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        bottomNavigationBar: MyBottomNavBar(),
    );
  }
}

class RelativeDetail extends StatelessWidget {
  final String name, number, email, documentID, userId;

  RelativeDetail(
      {this.name, this.number, this.email, this.documentID, this.userId});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('profile')
                .doc(userId)
                .collection('relatives')
                .doc(documentID)
                .delete();
          },
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditRelativesScreen(documentID);
          }));
        },
        leading: Icon(
          Icons.person_pin,
          size: 45,
          color: Colors.blueGrey[700],
        ),
        contentPadding: EdgeInsets.all(8),
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(name),
        ),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Number : '),
                Expanded(child: Text(number)),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Email : '),
                Expanded(child: Text(email))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
