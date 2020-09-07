import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';

NotificationDetails getNotificationDetails(){
  AndroidNotificationDetails android = AndroidNotificationDetails(
    'channel_id', 
    'channel_name', 
    'channel_description',

    visibility: NotificationVisibility.Public,
    priority: Priority.Max,
    importance: Importance.Max,

    ledColor: const Color.fromARGB(255,0, 200, 255),
    ledOffMs: 500,
    ledOnMs: 300,

    enableLights: true,

    color: Colors.blue,
    
    additionalFlags: Int32List.fromList([8]),
    category: 'reminder',

    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),

    enableVibration: true,
    vibrationPattern: Int64List.fromList([0,1000,1000,1000]),
  );
  IOSNotificationDetails ios = IOSNotificationDetails();
  NotificationDetails details = NotificationDetails(android, ios);
  return details;
}

Future<void> setDailyStartNotification(TimeOfDay time, String user)async{
  try{
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    NotificationDetails notificationDetails = getNotificationDetails();
    await plugin.cancel(0);
    await plugin.showDailyAtTime(
      0, 
      "Good Morning, $user", 
      "Don't forget to dring enoung water today", 
      Time(time.hour,time.minute), 
      notificationDetails
    );
  }catch(e){
    print(e);
  }
}

Future<void> waterNotification(int left)async {
  try{
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    NotificationDetails notificationDetails = getNotificationDetails();
    await plugin.cancel(1);
    await plugin.schedule(
      1, 
      "Hey, it's time to drink water", 
      "$left mL water left to drink today",
      DateTime.now().add(Duration(hours: 1,minutes: 30)),
      notificationDetails
    );
  }catch(e){
    print(e);
  }
}


Future<void> cancelAllNotifications() async{
  try{
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    await plugin.cancelAll();
  }catch(e){
    print(e);
  }
}