import 'package:drinkable/screens/auth_screen.dart';
import 'package:drinkable/screens/data_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';


class OnboardScreen extends StatefulWidget {
  final Function finish;
  OnboardScreen(this.finish);
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    //isFirstTime(context);
  }

  // void toggleLoading(){
  //   setState(() {
  //     _loading = !_loading;
  //   });
  // }

  // void isFirstTime(BuildContext context) async {
  //   toggleLoading();
  //   try{
  //     SharedPreferences _preferences = await SharedPreferences.getInstance();
  //     bool firstTime = _preferences.getBool('first_time');
  //     if(firstTime==null){
  //       toggleLoading();
  //       return;
  //     }else{
  //       User user = FirebaseAuth.instance.currentUser;
  //       if(user==null){
  //         print('user not logged in');
  //         Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
  //       }else{
  //         Navigator.of(context).popAndPushNamed(CustomDrawer.routeName);
  //       }
  //       return;
  //     }
  //   }catch(e){
  //     print(e);
  //   }
  //   toggleLoading();
  // }

  // Future<void> setFirstTime() async {
  //   toggleLoading();
  //   try{
  //     SharedPreferences _preferences = await SharedPreferences.getInstance();
  //     bool success = await _preferences.setBool('first_time', false);
  //     if(success){
  //       Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
  //       return;
  //     }
  //   }catch(e){
  //     print(e);
  //   }
  //   toggleLoading();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: _loading ? Image.asset('assets/icons/logo.png') : RaisedButton(
          child: Text('Go'),
          onPressed: (){
            //setFirstTime();
            widget.finish();
          } 
        ),
      )
    );
  }
}