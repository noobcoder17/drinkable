import 'package:drinkable/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// widgets
import '../widgets/custom_app_bar.dart';
import '../widgets/goal_and_add.dart';
import '../widgets/weather_suggestion.dart';
import '../widgets/loading_screen.dart';

// providers
import '../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  final Function openDrawer;
  HomeScreen({
    this.openDrawer
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  void toggleLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void init() async {
    toggleLoading();
    await Provider.of<HomeProvider>(context,listen: false).init();
    toggleLoading();
  }
  
  @override
  Widget build(BuildContext context) {
    return _isLoading ? LoadingScreen() : Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                openDrawer: widget.openDrawer,
                trailing: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    User user = authProvider.user;
                    return CircleAvatar(
                      radius: 19,
                      backgroundImage: NetworkImage(user.photoURL),
                    );
                  },
                  
                ),
              ),
              SizedBox(height: 40,),
              GoalAndAdd(),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.fromLTRB(30,0,30,20),
                child: WeatherSuggestion()
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: Color.fromARGB(255, 0, 60, 192),
        child: Icon(Icons.add,size: 30,),
        onPressed: (){

        }
      ),
    );
  }
}

