import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// utils
import '../utils/get_week.dart';

// models
import '../models/weekly_data.dart';
import '../models/user.dart';

class HomeProvider extends ChangeNotifier {
  WeeklyData _weeklyData;
  String _uid;
  AppUser _user;
  DateTime _today = DateTime.now();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference _weekColRef;
  DocumentReference _userRef;
  DocumentReference _currentWeek;
  Location _location = Location();
  Map<String,dynamic> weather;

  // HomeProvider(){
  //   _weekColRef = _firebaseFirestore.collection('users').doc(_uid).collection('week');
  //   _userRef = _firebaseFirestore.collection('users').doc(_uid);
  // }

  void updateUId(User user){
    print('Updating user in home provider');
    if(user!=null){
      _uid = user.uid;
      _weekColRef = _firebaseFirestore.collection('users').doc(_uid).collection('weeks');
      _userRef = _firebaseFirestore.collection('users').doc(_uid);
    }else{
      _uid = null;
      _weekColRef = null;
      _userRef = null;
    }
    notifyListeners();
  }

  String get dailyTarget {
    int target = _user.dailyTarget;
    if(target<1000){
      return '$target mL';
    }else{
      return '${(target/1000).toStringAsFixed(1)} L';
    }
    //return _user.dailyTarget;
  }

  String get leftAmount {
    int target = _user.dailyTarget;
    int consumed = _weeklyData.amounts[_today.weekday.toString()].toInt();
    int left = target-consumed;
    if(left<1000){
      return '$left mL';
    }else{
      return '${(left/1000).toStringAsFixed(1)} L';
    }
  }

  double get targetReached {
    int target = _user.dailyTarget;
    int consumed = _weeklyData.amounts[_today.weekday.toString()].toInt();
    return consumed/target;
  }

  Future<void> init()async{
    try {
      int week = getWeek(_today);
      String docId = '${_today.year}_$week';
      _currentWeek = _weekColRef.doc(docId);
      DocumentSnapshot userSnapshot = await _userRef.get();
      _user = AppUser.fromDoc(userSnapshot.data());
      DocumentSnapshot snapshot = await _currentWeek.get();
      if(!snapshot.exists){
        // print('Creating new weekly data');
        Map<String,dynamic> newWeek = WeeklyData().createNewWeek(docId,_today.year,_today.month,week);
        await _currentWeek.set(newWeek);
        _weeklyData = WeeklyData.fromDoc(newWeek);
      }else{
        // print('Weekly data alredy exists');
        _weeklyData = WeeklyData.fromDoc(snapshot.data());
      }
      notifyListeners();
      // LocationData _locationData = await _location.getLocation();
      // print(_locationData.latitude);
      // print(_locationData.longitude);
      // http.Response response = await http.get(
      //   'https://api.openweathermap.org/data/2.5/weather?lat=${_locationData.latitude}&lon=${_locationData.longitude}&appid=5c079888a15f3da50f160e44ce22723e&units=metric'
      // );
      // if(response.statusCode==200){
      //   final weatherInfo = jsonDecode(response.body);
      //   print(weatherInfo['main']);
      // }
    }catch(e){
      print(e);
    }
  }

  Future<void> addWater(int amount) async {
    try{
      int weekday = DateTime.now().weekday;
      _firebaseFirestore.runTransaction((transaction)async{
        DocumentReference yearDocRef = _firebaseFirestore.collection('users').doc(_uid).collection('years').doc('${_today.year}');
        DocumentReference monthDocRef = _firebaseFirestore.collection('users').doc(_uid).collection('months').doc('${_today.year}_${_today.month}');
        DocumentSnapshot yearDocSnap = await transaction.get(yearDocRef);
        DocumentSnapshot monthDocSnap = await transaction.get(monthDocRef);

        if(!yearDocSnap.exists){
          transaction.set(yearDocRef, {
            'year' : _today.year
          },SetOptions(merge: true));
        }

        if(!monthDocSnap.exists){
          transaction.set(monthDocRef, {
            'year' : _today.year,
            'month' : _today.month
          },SetOptions(merge: true));
        }

        transaction.update(yearDocRef, {
          'amounts.${_today.month}' : FieldValue.increment(amount)
        });

        transaction.update(monthDocRef, {
          'amounts.${_today.day}' : FieldValue.increment(amount)
        });
        transaction.update(_currentWeek, {
          'amounts.$weekday' : FieldValue.increment(amount)
        });

      });
      _weeklyData.amounts[weekday.toString()] += amount;
      notifyListeners();
    }catch(e){
      print(e);
    }
    
  }

  Future<void> getLocation()async{
    bool isServiceEnabled = await _location.serviceEnabled();
    print(isServiceEnabled);

    if(!isServiceEnabled){
      bool _enabled = await _location.requestService();
      if (_enabled) {
        print('Service is enabled now');
      }else{
        return;
      }
    }
    print('Service is already enables');

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      PermissionStatus _isGranted = await _location.requestPermission();
      if (_isGranted != PermissionStatus.granted) {
        return;
      }
    }
    print('Ok');
  }
}

