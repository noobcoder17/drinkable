import 'package:drinkable/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataEntryScreen extends StatelessWidget {
  static const routeName = 'data-entry-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data entry'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Lest go'),
          onPressed: ()async{
            await Provider.of<AuthProvider>(context,listen: false).signUp();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}