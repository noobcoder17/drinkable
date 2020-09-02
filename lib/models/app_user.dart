import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppUser {
  String uid;
  String googleId;
  String email;
  String name;
  String gender;
  DateTime birthday;
  double weight;
  TimeOfDay wakeUpTime;
  int dailyTarget;

  AppUser({
    this.uid,
    this.googleId,
    this.email,
    this.name,
    this.gender,
    this.birthday,
    this.weight,
    this.wakeUpTime,
    this.dailyTarget
  });

  factory AppUser.fromDoc(Map<String,dynamic> doc){
    return AppUser(
      uid: doc['uid'],
      name: doc['name'],
      dailyTarget: doc['daily_target']
    );
  }
  toDoc(){
    return {
      'uid' : this.uid,
      'google_id' : this.googleId,
      'email' : this.email,
      'name' : this.name,
      'gender' : this.gender,
      'birthday' : Timestamp.fromDate(this.birthday),
      'weight' : this.weight,
      'wake_up_time' : {
        'hour' : this.wakeUpTime.hour,
        'minute' : this.wakeUpTime.minute
      },
      'daily_target' : dailyTarget
    };
  }
}