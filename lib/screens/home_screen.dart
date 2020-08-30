import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/custom_app_bar.dart';
import '../widgets/goal_and_add.dart';
import '../widgets/weather_suggestion.dart';

// providers
import '../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
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
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Container(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(),
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
    );
  }
}

