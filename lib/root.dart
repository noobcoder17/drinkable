import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// providers
import './providers/auth_provider.dart';

// screens
import './screens/auth_screen.dart';

// widgets
import './widgets/custom_drawer.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
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