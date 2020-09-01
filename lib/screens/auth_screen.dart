import 'package:drinkable/providers/auth_provider.dart';
import 'package:drinkable/screens/data_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void selectAccount(BuildContext ctx) async {
    toggleLoading();
    bool newuser = await Provider.of<AuthProvider>(ctx,listen: false).selectGoogleAcount();
    print('new user $newuser');
    if(!newuser){
      await Provider.of<AuthProvider>(ctx,listen: false).signIn();
    }else{
      toggleLoading();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/big_logo.png',height: 90,),
                    SizedBox(height: 10,),
                    Text(
                      'drinkable',
                      style: GoogleFonts.pacifico(
                        fontWeight: FontWeight.w500,
                        fontSize: 26,
                        color: Color.fromARGB(255, 0, 60, 192),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 250
                      ),
                      child: Text(
                        'Drinkable keeps track your daily water intake and reminds you to drink water by sending notification in intervals',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.60)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _loading ? CircularProgressIndicator() : Consumer<AuthProvider>(
                  builder: (ctx, authProvider, child) {
                    GoogleSignInAccount googleAccount = authProvider.googleAcount;
                    return googleAccount!=null ? 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(googleAccount.photoUrl),
                        ),
                        FlatButton(
                          child: Text('Continue as ${googleAccount.displayName}'),
                          onPressed: (){
                            Navigator.of(context).pushNamed(DataEntryScreen.routeName);
                          },
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            Provider.of<AuthProvider>(ctx,listen: false).clearGoogleAccount();
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Icon(Icons.clear),
                          ),
                        ),
                      ],
                    ) : GestureDetector(
                      onTap: (){
                        selectAccount(context);
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Image.asset('assets/icons/google.png',height: 20,)
                              ),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12
                      ),
                      children: [
                        TextSpan(
                          text: 'By signing up you accept the ',
                        ),
                        TextSpan(
                          text:  'Terms of Service and Privacy Policy.',
                          style: TextStyle(
                            fontWeight: FontWeight.w500
                          )
                        )
                      ]
                    ),
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}