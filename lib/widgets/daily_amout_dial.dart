import 'package:flutter/material.dart';
import 'dart:math';

class DailyAmountDial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: -pi/2,
          child: Container(
            width: 145,
            height: 145,
            child: CustomPaint(
              painter: DialPainter(),
            ),
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '0.3 L',
                style: TextStyle(fontSize: 33,fontWeight: FontWeight.w700)
              ),
              TextSpan(text:'\n'),
              TextSpan(
                text: 'left to drink',
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)
              ),
            ]
          ),
        )
      ],
    );
  }
}

class DialPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.height/2,size.width/2);
    double fullRadius = (size.height/2);
    Paint circle = Paint()..color=Colors.white.withOpacity(0.2)..strokeWidth=4..style=PaintingStyle.stroke;
    Paint arc = Paint()..color = Colors.white..strokeCap=StrokeCap.round..style=PaintingStyle.stroke..strokeWidth=6;
    canvas.drawCircle(Offset(size.width/2,size.height/2), fullRadius-2,circle);
    canvas..drawArc(Rect.fromCircle(center: center,radius: fullRadius-2), 0, pi, false, arc);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  
}