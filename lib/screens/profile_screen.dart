import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  final Function openDrawer;
  ProfileScreen({
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
              CustomAppBar(openDrawer: openDrawer),
            ],
          ),
        ),
      ),
    );
  }
}