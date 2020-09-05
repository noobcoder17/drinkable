import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// utils
import '../utils/get_week.dart';

//values
import '../values/api_key.dart';

// models
import '../models/weekly_data.dart';
import '../models/app_user.dart';

class HomeProvider extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Location _location = Location();
  bool _isInited = false;
  DateTime _today = DateTime.now();

  WeeklyData _weeklyData;
  String _uid;
  AppUser _appUser;

  CollectionReference _weekColRef;
  DocumentReference _userRef;
  DocumentReference _currentWeek;

  Map<String,dynamic> _weather;
  LocationData _locationData;

  void update(User user){
    if(user!=null){
      _uid = user.uid;
      _weekColRef = _firebaseFirestore.collection('users').doc(_uid).collection('weeks');
      _userRef = _firebaseFirestore.collection('users').doc(_uid);
    }else{
      _isInited = false;
      _uid = null;
      _appUser = null;
      _weekColRef = null;
      _userRef = null;
    }
    notifyListeners();
  }

  Map<String,dynamic> get weather {
    return _weather;
  }

  String get dailyTarget {
    int target = _appUser.dailyTarget;
    if(target<1000){
      return '$target mL';
    }else{
      return '${(target/1000).toStringAsFixed(1)} L';
    }
  }

  int get leftAmount {
    int target = _appUser.dailyTarget;
    int consumed = _weeklyData.amounts[_today.weekday.toString()].toInt();
    int left = target-consumed;
    return left;
  }

  double get targetReached {
    int target = _appUser.dailyTarget;
    int consumed = _weeklyData.amounts[_today.weekday.toString()].toInt();
    return consumed/target;
  }

  AppUser get appUser => _appUser;

  Future<void> init()async{
    if(_isInited==false){
      try {
        int week = getWeek(_today);
        String docId = '${_today.year}_$week';
        _currentWeek = _weekColRef.doc(docId);
        DocumentSnapshot userSnapshot = await _userRef.get();
        _appUser = AppUser.fromDoc(userSnapshot.data());
        DocumentSnapshot snapshot = await _currentWeek.get();
        if(!snapshot.exists){
          Map<String,dynamic> newWeek = WeeklyData().createNewWeek(docId,_today.year,_today.month,week,_appUser.dailyTarget);
          await _currentWeek.set(newWeek);
          _weeklyData = WeeklyData.fromDoc(newWeek);
        }else{
          _weeklyData = WeeklyData.fromDoc(snapshot.data());
        }
        _isInited = true;
        bool canGetLocation = await getLocationService();
        if(canGetLocation){
          _locationData = await _location.getLocation();
          http.Response response = await http.get(
            'https://api.openweathermap.org/data/2.5/weather?lat=${_locationData.latitude}&lon=${_locationData.longitude}&appid=${keys['openweather']}&units=metric'
          );
          if(response.statusCode==200){
            final weatherInfo = jsonDecode(response.body);
            _weather = weatherInfo['weather'][0];
          }
        }
        notifyListeners();
      }catch(e){
        print(e);
      }
    }else{
      print('Data already inited');
    }
  }

  Future<void> addWater(int amount,DateTime time) async {
    try{
      int weekday = time.weekday;
      int week = getWeek(time);
      String weekId = '${time.year}_$week';
      await _firebaseFirestore.runTransaction((transaction)async{
        DocumentReference weekDocRef = _firebaseFirestore.collection('users').doc(_uid).collection('weeks').doc(weekId);
        DocumentReference yearDocRef = _firebaseFirestore.collection('users').doc(_uid).collection('years').doc('${time.year}');
        DocumentReference monthDocRef = _firebaseFirestore.collection('users').doc(_uid).collection('months').doc('${time.year}_${time.month}');
        DocumentSnapshot yearDocSnap = await transaction.get(yearDocRef);
        DocumentSnapshot monthDocSnap = await transaction.get(monthDocRef);
        DocumentSnapshot weekDocSnap = await transaction.get(weekDocRef);

        if(!yearDocSnap.exists){
          transaction.set(yearDocRef, {
            'year' : time.year
          },SetOptions(merge: true));
        }

        if(!monthDocSnap.exists){
          transaction.set(monthDocRef, {
            'year' : time.year,
            'month' : time.month
          },SetOptions(merge: true));
        }

        if(!weekDocSnap.exists){
          transaction.set(weekDocRef, {
            'daily_target' : _appUser.dailyTarget,
            'year' : time.year,
            'month' : time.month,
            'week' : week,
            'id' : weekId,
          },SetOptions(merge: true));
        }

        transaction.update(yearDocRef, {
          'amounts.${time.month}' : FieldValue.increment(amount)
        });

        transaction.update(monthDocRef, {
          'amounts.${time.day}' : FieldValue.increment(amount)
        });
        transaction.update(weekDocRef, {
          'amounts.$weekday' : FieldValue.increment(amount)
        });

      });
      if(_weeklyData.id==weekId){
        _weeklyData.amounts[weekday.toString()] += amount;
        notifyListeners();
      }
    }catch(e){
      print(e);
    }
    
  }

  Future<bool> getLocationService()async{
    bool isServiceEnabled = await _location.serviceEnabled();

    if(!isServiceEnabled){
      bool _enabled = await _location.requestService();
      if (_enabled) {
      }else{
        return false;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      PermissionStatus _isGranted = await _location.requestPermission();
      if (_isGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> updateUser(AppUser appUser)async{
    try{
     await _firebaseFirestore.runTransaction((transaction)async{
        transaction.update(_currentWeek,{
          'daily_target' : appUser.dailyTarget
        });
        transaction.update(_userRef, appUser.toDoc());
      });
      _appUser = appUser;
      notifyListeners();
    }catch(e){
      print(e);
    }
  } 
}

