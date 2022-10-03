import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_time_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../components/navBar.dart';
import '../../../models/reminder.dart';
import '../../../services/database_helper.dart';

import '../../../services/notifications.dart';
import 'medicine_reminder.dart';

class ReminderDetail extends StatefulWidget {
  static const String routeName = 'Medicine_detail_screen';

  final String pageTitle;
  final Reminder reminder;

  ReminderDetail(this.reminder, [this.pageTitle]);

  @override
  State<StatefulWidget> createState() {
    return _ReminderDetailState(this.reminder, this.pageTitle);
  }
}

class _ReminderDetailState extends State<ReminderDetail> {
  final auth = FirebaseAuth.instance;
  User loggedInUser;

  DatabaseHelper helper = DatabaseHelper();
  Reminder reminder, tempReminder;
  String pageTitle;
  var rng = Random();
  NotificationService notificationService;
  _ReminderDetailState(this.reminder, this.pageTitle);

  TimeOfDay selectedTime1, selectedTime2, selectedTime3, t1, t2, t3;
  TimeOfDay timeNow = TimeOfDay.now();

  int times = 2;

  String medicineName = '', tempName = '', medicineType = '';
  Map<String, dynamic> intakeHistory;
  File pickedImage;
  bool isImageLoaded = false;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = File(pickedFile.path);
      isImageLoaded = true;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    super.dispose();
    getCurrentUser();
    notificationService = NotificationService();
    notificationService.initialize();
  }

  String tempTime1, tempTime2, tempTime3;
  List<String> timeStringList;

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

  @override
  void initState() {
    tempReminder = widget.reminder;
    medicineName = nameController.text = reminder.name;
    medicineType = typeController.text = reminder.type;
    times = reminder.times;

    tempTime1 = reminder.time1;
    intakeHistory = reminder.intakeHistory;
    tempTime2 = reminder.time2;

    tempTime3 = reminder.time3;
    selectedTime1 = t1 = TimeOfDay(
            hour: int.parse(tempTime1.split(":")[0]),
            minute: int.parse(tempTime1.split(":")[1])) ??
        TimeOfDay(hour: 0, minute: 0);

    selectedTime2 = t2 = TimeOfDay(
            hour: int.parse(tempTime2.split(":")[0]),
            minute: int.parse(tempTime2.split(":")[1])) ??
        TimeOfDay(hour: 0, minute: 0);
    selectedTime3 = t3 = TimeOfDay(
            hour: int.parse(tempTime3.split(":")[0]),
            minute: int.parse(tempTime3.split(":")[1])) ??
        TimeOfDay(hour: 0, minute: 0);
    super.initState();
    notificationService = NotificationService();
    notificationService.initialize();
  }

  final nameController = TextEditingController();
  final typeController = TextEditingController();

  Future readText() async {
    setState(() {
      nameController.value = TextEditingValue(text: '');
      nameController.text = '';
      medicineName = '';
      tempName = null;
      isImageLoaded = false;
    });

    GoogleVisionImage googleVisionImage =
        GoogleVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = GoogleVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(googleVisionImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          tempName = word.text;
        }
      }
    }
    setState(() {
      if (medicineName == '') {
        medicineName = tempName;
        nameController.text = medicineName;
      } else {
        medicineName = '';
        nameController.clear();
        isImageLoaded = false;
        tempName = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      body: WillPopScope(
        onWillPop: () async {
          if (reminder !=
              Reminder(
                  medicineName,
                  medicineType,
                  selectedTime1.toString(),
                  selectedTime2.toString(),
                  selectedTime3.toString(),
                  times,
                  reminder.notificationID,
                  intakeHistory)) {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RichAlertDialog(
                    alertTitle: richTitle("Reminder Not Saved"),
                    alertSubtitle: richSubtitle('Changes will be discarded '),
                    alertType: RichAlertType.WARNING,
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
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
          } else
            return true;
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 30,
                      fontWeight: FontWeight.w100),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: ReminderFormItem(
                      helperText: 'Name of Reminder',
                      hintText: 'Enter Medicine Name',
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          medicineName = value.toString();
                        });
                      },
                      isNumber: false,
                      icon: FontAwesomeIcons.capsules,
                    ),
                  ),
                  Expanded(
                    child: Tooltip(
                      message: 'Detect Name from Image',
                      child: GestureDetector(
                        child: Icon(
                          Icons.camera,
                          color: isImageLoaded
                              ? Colors.blue[100]
                              : Colors.blueGrey,
                          size: 43,
                        ),
                        onTap: () async {
                          await getImage();
                          nameController.clear();
                          medicineName = '';
                          await readText();
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ReminderFormItem(
                helperText: 'Give the type for reference',
                hintText: 'Enter type of medicine',
                controller: typeController,
                onChanged: (value) {
                  setState(() {
                    medicineType = value;
                  });
                },
                isNumber: false,
                icon: FontAwesomeIcons.prescriptionBottle,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 10),
                child: Text(
                  'Times a day : ',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Once : '),
                    Radio(
                      onChanged: (value) {
                        setState(() {
                          times = value;
                        });
                      },
                      activeColor: Color(0xffff9987),
                      value: 1,
                      groupValue: times,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Twice : '),
                    Radio(
                      onChanged: (value) {
                        setState(() {
                          times = value;
                        });
                      },
                      activeColor: Color(0xffff9987),
                      value: 2,
                      groupValue: times,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Thrice : '),
                    Radio(
                      activeColor: Color(0xffff9987),
                      onChanged: (value) {
                        setState(() {
                          times = value;
                        });
                      },
                      value: 3,
                      groupValue: times,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  times == 1
                      ? SizedBox(
                          width: 80,
                        )
                      : SizedBox(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showMaterialTimePicker(
                          context: context,
                          selectedTime: selectedTime1,
                          onChanged: (value) =>
                              setState(() => selectedTime1 = value),
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
                  ),
                  times >= 2
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showMaterialTimePicker(
                                context: context,
                                selectedTime: selectedTime2,
                                onChanged: (value) =>
                                    setState(() => selectedTime2 = value),
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
                        )
                      : SizedBox(),
                  times == 3
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showMaterialTimePicker(
                                context: context,
                                selectedTime: selectedTime3,
                                onChanged: (value) =>
                                    setState(() => selectedTime3 = value),
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
                        )
                      : SizedBox(),
                  times == 1
                      ? SizedBox(
                          width: 80,
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  times >= 1 && selectedTime1 != TimeOfDay(hour: 0, minute: 0)
                      ? Text('Time 1 :  ' + selectedTime1.format(context))
                      : SizedBox(),
                  times >= 2 && selectedTime2 != TimeOfDay(hour: 0, minute: 0)
                      ? Text('Time 2 :  ' + selectedTime2.format(context))
                      : SizedBox(
                          height: 8,
                        ),
                  times == 3 && selectedTime3 != TimeOfDay(hour: 0, minute: 0)
                      ? Text('Time 3 :  ' + selectedTime3.format(context))
                      : SizedBox(
                          height: 8,
                        ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  primary: Color(0xffff9987),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.redAccent[100],
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                label: Text('Save'),
                icon: Icon(Icons.save),
                onPressed: () async {
                  setState(() {
                    reminder.times = times;
                    reminder.name = medicineName;
                    reminder.type = medicineType;
                    if (times >= 1)
                      reminder.time1 = selectedTime1.hour.toString() +
                          ':' +
                          selectedTime1.minute.toString();
                    if (times >= 2)
                      reminder.time2 = selectedTime2.hour.toString() +
                          ':' +
                          selectedTime2.minute.toString();
                    else
                      reminder.time2 = '00:00';
                    if (times == 3)
                      reminder.time3 = selectedTime3.hour.toString() +
                          ':' +
                          selectedTime3.minute.toString();
                    else
                      reminder.time3 = '00:00';
                  });
                  _save();
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  // Save data to database
  void _save() async {
    int result;
    if (reminder.id != null) {
      // Case 1: Update operation
      result = await helper.updateReminder(reminder);
      if (tempReminder != reminder) {
        notificationService.removeReminder(reminder.id);
        if (selectedTime1 != t1) {
          log(selectedTime1.hour);
          notificationService.registerMessage(
            hour: selectedTime1.hour,minutes: selectedTime1.minute,title: "hello",body: ""
          );
          // notificationService.schedNotification(
          //     1, "title", "body", selectedTime1.hour, selectedTime1.minute);
          // notificationService.dailyMedicineNotification(
          //     id: reminder.notificationID,
          //     title: 'Medicine Reminder',
          //     body: 'Please take your ' + reminder.name + ' on time! ',
          //     time: Time(selectedTime1.hour, selectedTime1.minute, 0));
        }
        if (times >= 2) {
          if (selectedTime2 != t2) {
            notificationService.dailyMedicineNotification(
                id: reminder.notificationID,
                title: 'Medicine Reminder',
                body: 'Please take your ' + reminder.name + ' on time! ',
                time: Time(selectedTime2.hour, selectedTime2.minute, 0));
          }
        }
        if (times == 3) {
          if (selectedTime3 != t3) {
            notificationService.dailyMedicineNotification(
                id: reminder.notificationID,
                title: 'Medicine Reminder',
                body: 'Please take your ' + reminder.name + ' on time! ',
                time: Time(selectedTime3.hour, selectedTime3.minute, 0));
          }
        }
      }
    } else {
      // Case 2: Insert Operation
      reminder.notificationID = rng.nextInt(9999);
      result = await helper.insertReminder(reminder);
      if (selectedTime1 != t1) {
              notificationService.registerMessage(
                id: 988,
            hour: selectedTime1.hour,minutes: selectedTime1.minute,title: "Medicine Reminder",body: "Please take your ' + reminder.name + ' on time! ",
          );
        // notificationService.schedNotification(
        //     1, "title", "body", selectedTime1.hour, selectedTime1.minute);
        // notificationService.dailyMedicineNotification(
        //     id: reminder.notificationID,
        //     title: 'Medicine Reminder',
        //     body: 'Please take your ' + reminder.name + ' on time! ',
        //     time: Time(selectedTime1.hour, selectedTime1.minute, 0));
      }
      if (times >= 2) {
        if (selectedTime2 != t2) {
          notificationService.dailyMedicineNotification(
              id: reminder.notificationID,
              title: 'Medicine Reminder',
              body: 'Please take your ' + reminder.name + ' on time! ',
              time: Time(selectedTime2.hour, selectedTime2.minute, 0));
        }
      }
      if (times == 3) {
        if (selectedTime3 != t3) {
          notificationService.dailyMedicineNotification(
              id: reminder.notificationID,
              title: 'Medicine Reminder',
              body: 'Please take your ' + reminder.name + ' on time! ',
              time: Time(selectedTime3.hour, selectedTime3.minute, 0));
        }
      }
    }
    if (result != 0) {
      //Success
      _showAlertDialog('Status', 'Reminder Saved Successfully');
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MedicineReminder();
      }));

      Navigator.pop(context);
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Reminder');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

class ReminderFormItem extends StatelessWidget {
  final String hintText;
  final String helperText;
  final Function onChanged;
  final bool isNumber;
  final IconData icon;
  final controller;

  ReminderFormItem(
      {this.hintText,
      this.helperText,
      this.onChanged,
      this.icon,
      this.isNumber: false,
      this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        maxLines: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Colors.indigo, style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
        ),
        onChanged: (String value) {
          onChanged(value);
        },
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
