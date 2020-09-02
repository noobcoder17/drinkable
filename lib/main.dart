import 'package:drinkable/screens/data_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// screens
import './screens/test.dart';

// providers
import './providers/home_provider.dart';
import './providers/auth_provider.dart';

import './root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,    
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider,HomeProvider>(
          create: (context) => HomeProvider(),
          update: (context, authProvider, homeProvider) => homeProvider..update(authProvider.user),
        )
      ],
      child: MaterialApp(
        //showPerformanceOverlay: true,
        title: 'Drinkable',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home: HomeScreen(),
        //home: CustomDrawer(),
        home: Root(),
        //home: TestScreen(),
        //home: OnboardScreen(),
        routes: {
          // '/' : (ctx)=>OnboardScreen(),
          DataEntryScreen.routeName : (ctx)=>DataEntryScreen(),
          // AuthScreen.routeName : (ctx)=>AuthScreen(),
          // CustomDrawer.routeName : (ctx)=>CustomDrawer()
        },
      ),
    );
  }
}