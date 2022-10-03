import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roro_medicine_reminder/generated/l10n.dart';
import 'package:roro_medicine_reminder/services/notifications.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../reminder/medicine/reminder_detail.dart';

class AddToReminder extends StatefulWidget {
  const AddToReminder({Key key}) : super(key: key);

  @override
  State<AddToReminder> createState() => _AddToReminderState();
}

class _AddToReminderState extends State<AddToReminder> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    var android = AndroidInitializationSettings("assets/images/image1.png");
    var ios = IOSInitializationSettings();
    var initializeSetting = InitializationSettings(
      android: android,
      iOS: ios,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializeSetting,
        onSelectNotification: _onSelectedNotification);

    //service.initialize();
  }

  void dateTime() {}

  Future displayNotification() async {
    var androidNotification = AndroidNotificationDetails(
        "channelId", "channelName",
        importance: Importance.high);
    var iosNotification = IOSNotificationDetails();
    var generalSetting =
        NotificationDetails(android: androidNotification, iOS: iosNotification);

    var scheduledTime;

    // scheduledTime = TZDateTime;
    if (slectedTime1 == slectedTime1.hour) {
      scheduledTime = DateTime.now().add(Duration(hours: slectedTime1.hour));
    } else if (slectedTime1 == slectedTime1.minute) {
      scheduledTime =
          DateTime.now().add(Duration(minutes: slectedTime1.minute));
    } else {
      scheduledTime = DateTime.now().add(Duration(seconds: 2));
      log(scheduledTime.toString());
    }

    // flutterLocalNotificationsPlugin.schedule(
    //     1, medicineType, "Get your medicine", scheduledTime, generalSetting);
    UILocalNotificationDateInterpretation localNotificationDateInterpretation;
    flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        medicineType,
        "body",
        tz.TZDateTime.now(tz.getLocation(tz.tzDataDefaultFilename))
            .add(const Duration(seconds: 5)),
        generalSetting,
        uiLocalNotificationDateInterpretation:
            localNotificationDateInterpretation,
        androidAllowWhileIdle: true);
  }

  TimeOfDay slectedTime1 = TimeOfDay.now();
  showNotification() {}
  NotificationService service;
  var hours;
  var minutes;
  var seconds;
  String medicineType;
  int times = 2;
  TextEditingController textController;
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ROROAppBar(),
        body: SafeArea(
            child: Column(
          children: [
            // TextFormField(
            //   controller: textController,
            //   decoration: InputDecoration(helperText: "Add Medicine"),
            // ),
            ReminderFormItem(
              helperText: 'Give the type for reference',
              hintText: 'Enter type of medicine',
              controller: textController,
              onChanged: (value) {
                setState(() {
                  medicineType = value;
                });
              },
              isNumber: false,
              icon: FontAwesomeIcons.prescriptionBottle,
            ),
            Text(
              medicineType ?? "",
              style: TextStyle(fontSize: 30),
            ),
            isClicked
                ? Column(
                    children: [
                      Text(
                        slectedTime1.format(context) ?? "",
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        "Hours :  $hours" ?? "",
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        "Minutes :  $minutes" ?? "",
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  )
                : SizedBox(),
            GestureDetector(
              onTap: () {
                showMaterialTimePicker(
                  context: context,
                  selectedTime: slectedTime1,
                  onChanged: (value) => setState(() {
                    slectedTime1 = value;
                    hours = slectedTime1.hour;
                    minutes = slectedTime1.minute;
                  }),
                );
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.access_alarm,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    isClicked = true;
                  });
                  displayNotification();
                },
                child: Text("Save")),
          ],
        )));
  }

  Future _onSelectedNotification(String playLoad) async {}
}
