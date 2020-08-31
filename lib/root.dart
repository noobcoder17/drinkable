import 'package:drinkable/providers/auth_provider.dart';
import 'package:drinkable/screens/auth_screen.dart';
import 'package:drinkable/screens/onboard_screen.dart';
import 'package:drinkable/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool _loading = false;
  bool _firstTime;


  @override
  void initState() {
    super.initState();
    isFirstTime();
  }

  void toggleLoading(){
    setState(() {
      _loading = !_loading;
    });
  }

  void isFirstTime() async {
    toggleLoading();
    try{
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      bool firstTime = _preferences.getBool('first_time');
      if(firstTime==null){
        _firstTime = true;
      }else{
        _firstTime = false;
      }
    }catch(e){
      print('First time ${true}');
    }
    toggleLoading();
  }

  Future<void> setFirstTime() async {
    toggleLoading();
    try{
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      bool success = await _preferences.setBool('first_time', false);
      if(success){
        _firstTime = false;
      }
    }catch(e){
      print(e);
    }
    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? Scaffold(body: Center(child: CircularProgressIndicator(),),) :
    _firstTime ? OnboardScreen(this.setFirstTime) : 
    Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        User user = authProvider.user;
        if(user==null){
          return AuthScreen();
        }
        return CustomDrawer();
      },
    );
  }
}