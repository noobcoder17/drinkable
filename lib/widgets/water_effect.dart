import 'package:flutter/material.dart';

class WaterEffect extends StatefulWidget {
  @override
  _WaterEffectState createState() => _WaterEffectState();
}

class _WaterEffectState extends State<WaterEffect> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _curvedAnimation = CurvedAnimation(curve: Curves.easeOutCubic,parent: _animationController);
    _animationController.repeat(reverse: true);
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipPath(
          clipper: MyClipper(),
            child: Container(
            constraints: constraints,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                    color: Color(0xff007af9),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0,-constraints.maxWidth*0.20-20*_curvedAnimation.value),
                      child: child
                    );
                  },
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth,
                      color: Color(0xff006ff8),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path()
    ..lineTo(0, size.height*0.80)
    //..lineTo(size.width*0.25,size.height*0.90)
    ..quadraticBezierTo(size.width*0.125, size.height*0.83, size.width*0.25, size.height*0.90)
    ..quadraticBezierTo(size.width*0.625, size.height*1.10, size.width, size.height*0.90)
    //..lineTo(size.width, size.height*0.90)
    ..lineTo(size.width, size.height*0.10)
    ..quadraticBezierTo(size.width*0.625, size.height*0.30, size.width*0.25, size.height*0.10)
    ..quadraticBezierTo(size.width*0.125, size.height*0.03, 0, 0)
    //..lineTo(size.width*0.25, size.height*0.10)
    ..close();
      
    return path;
  }
  
    @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
  
}