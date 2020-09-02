import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';

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
              CustomAppBar(
                openDrawer: openDrawer,
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
            ],
          ),
        ),
      ),      
    );
  }
}