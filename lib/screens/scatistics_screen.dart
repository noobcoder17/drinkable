import 'package:flutter/material.dart';

// widgets
import '../widgets/custom_app_bar.dart';

class StatisticsScreen extends StatelessWidget {
  final Function openDrawer;
  StatisticsScreen({
    this.openDrawer
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(openDrawer),
            ],
          ),
        ),
      ),      
    );
  }
}