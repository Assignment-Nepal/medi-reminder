
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';
import 'package:http/http.dart' as http;
import '../../../components/navBar.dart';
import '../../../models/appoinment.dart';
import '../../../services/database_helper.dart';

class AppoinmentDecision extends StatefulWidget {
  static const String routeName = 'Appoinment_decision_screen';
  final Appoinment appoinment;
  AppoinmentDecision(this.appoinment);
  @override
  _AppoinmentDecisionState createState() => _AppoinmentDecisionState();
}

class _AppoinmentDecisionState extends State<AppoinmentDecision> {
  sendSms() async {
    var cred =
        'AC07a649c710761cf3a0e6b96048accf58:60cfd08bcc74ea581187a048dfd653cb';

    var bytes = utf8.encode(cred);

    var base64Str = base64.encode(bytes);

    var url =
        'https://api.twilio.com/2010-04-01/Accounts/AC07a649c710761cf3a0e6b96048accf58/Messages.json';

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Basic $base64Str'
        }, body: {
          'From': '+12567403927',
          'To': '+918078214942',
          'Body': 'Just missed their appointment!'
        });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  DatabaseHelper helper = DatabaseHelper();
  Appoinment appoinment;
  @override
  void initState() {
    appoinment = widget.appoinment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Did you visit ' + appoinment.name,
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          size: 90,
                          color: Colors.white,
                        )),
                    onTap: () async {
                      appoinment.done = true;
                      await helper.updateAppoinment(appoinment);
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          size: 90,
                          color: Colors.white,
                        )),
                    onTap: () async {
                      appoinment.done = false;
                      await helper.updateAppoinment(appoinment);
                      setState(() {});
                      await sendSms();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    'If you dont respond within 15 minutes information will be sent to your JagaMe.'))
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
