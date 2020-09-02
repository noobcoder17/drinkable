import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
   AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (3*0.5*2222).toInt())
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: TweenSequence(
            <TweenSequenceItem<Color>>[
              TweenSequenceItem<Color>(
                tween: ConstantTween<Color>(Color.fromARGB(255, 0, 60, 192)),
                weight: 33.33,
              ),
              TweenSequenceItem<Color>(
                tween: ConstantTween<Color>(Color.fromARGB(255, 0, 140, 238)),
                weight: 33.33,
              ),
              TweenSequenceItem<Color>(
                tween: ConstantTween<Color>(Color.fromARGB(255,11, 209, 252)),
                weight: 33.33,
              ),
            ],
          ).animate(_animationController),
        ),
      ),
    );
  }
}