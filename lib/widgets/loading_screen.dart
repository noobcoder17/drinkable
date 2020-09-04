import 'package:flutter/material.dart';

// widgets
import './custom_progress_indicator.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomProgressIndicatior()
      ),
    );
  }
}

