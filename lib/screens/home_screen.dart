import 'package:flutter/material.dart';

// widgets
import '../widgets/custom_app_bar.dart';
import '../widgets/goal_and_add.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weather',
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Color(0xff0064cd),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Image.asset('assets/icons/025-sun.png',width: 40,),
                        ),
                        SizedBox(width: 40,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: 'It\'s',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w300)),
                                    TextSpan(text: ' hot ',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700)),
                                    TextSpan(text: 'today',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w300)),
                                  ]
                                ),
                              ),
                              SizedBox(height: 15,),
                              Text(
                                'Dont\'t forget to take your water bottle with you',
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

