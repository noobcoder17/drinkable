import 'package:drinkable/providers/auth_provider.dart';
import 'package:drinkable/screens/data_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _loading = false;

  void toggleLoading(){
    setState(() {
      _loading = !_loading;
    });
  }

  // void checkSignedIn(BuildContext context) async {
  //   toggleLoading();
  //   try{
  //     User user = await FirebaseAuth.instance.currentUser;
  //     if(user==null){
  //       print('user not logged in');
  //       //toggleLoading();
  //     }else{
  //       Navigator.of(context).popAndPushNamed(CustomDrawer.routeName);
  //       return;
  //     }
  //   }catch(e){
  //     print(e);
  //   }
  // }
  @override
  Widget build(BuildContext ctx) {
    print('Auth screen');
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: ()async{
              toggleLoading();
              bool newuser = await Provider.of<AuthProvider>(ctx,listen: false).selectGoogleAcount();
              print('new user $newuser');
              if(!newuser){
                await Provider.of<AuthProvider>(ctx,listen: false).signIn();
                //Navigator.of(context).popAndPushNamed(CustomDrawer.routeName);
              }else{
                toggleLoading();
              }
            } 
          )
        ],
      ),
      body: Center(
        child:_loading ? CircularProgressIndicator() : Consumer<AuthProvider>(
          builder: (context, value, child) {
            GoogleSignInAccount googleAccount = value.googleAcount;
            return googleAccount!=null ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(googleAccount.photoUrl),
                ),
                Text(googleAccount.displayName),
                Text(googleAccount.email),
                RaisedButton(
                  onPressed: (){
                    Navigator.of(ctx).pushNamed(DataEntryScreen.routeName);
                  },
                )
              ],
            ) : Text('No account selected');
          },
        )
      ),
    );
  }
}