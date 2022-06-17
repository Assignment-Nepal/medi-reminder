import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NotificationService with ChangeNotifier {
  var flutterLocalNotificationsPlugin;

  NotificationService() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    initialize();
  }

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

  void initialize()  {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    //var initializationSettingsIOS = IOSInitializationSettings(
    //onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }


  void showNotificationDaily(
      int id, String title, String body, int hour, int minute) async {
    var time = new Time(hour, minute, 0);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, time, getPlatformChannelSpecfics());
    print('Notification Succesfully Scheduled at ${time.toString()}');
    notifyListeners();
  }

  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        ticker:'Medicine reminder'
        //playSound: true,
        //sound:RawResourceAndroidNotificationSound('notification_sound'),

    );
    //var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }
  scheduleAppoinmentNotification(
      {@required int id,
        @required String title,
        @required String body,
        @required DateTime dateTime}) async {
    var scheduledNotificationDateTime = dateTime;
    await flutterLocalNotificationsPlugin.schedule(id, title, body,
        scheduledNotificationDateTime, getPlatformChannelSpecfics());
  }

  scheduleNotification(
      {@required int id,
        @required String title,
        @required String body,
        @required DateTime dateTime}) async {
    var scheduledNotificationDateTime = dateTime;

    await flutterLocalNotificationsPlugin.schedule(id, title, body,
        scheduledNotificationDateTime, getPlatformChannelSpecfics());
  }

  periodicNotification(
      {@required int id,
        @required String title,
        @required String body,
        @required DateTime dateTime}) async {

    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, getPlatformChannelSpecfics());
  }

  dailyNotification() async {
    var time = Time(10, 0, 0);


    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately ',
        time,
        getPlatformChannelSpecfics());
  }

  dailyMedicineNotification(
      {@required int id,
        @required String title,
        @required String body,
        @required Time time}) async {

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, time, getPlatformChannelSpecfics());
  }

  weeklyNotification() async {
    var time = Time(10, 0, 0);

    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'show weekly title',
        'Weekly notification shown on Monday at approximately',
        Day.monday,
        time,
        getPlatformChannelSpecfics());
  }

  notificationDetails() async {
    var notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    print(notificationAppLaunchDetails.didNotificationLaunchApp);
    print(notificationAppLaunchDetails.payload);
    return notificationAppLaunchDetails;
  }
  Future onSelectNotification(String payload) async {
    await FlutterRingtonePlayer.stop();
  }


  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return Future.value(1);
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}