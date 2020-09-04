import 'package:flutter/material.dart';
import 'dart:math';

class WaterEffect extends StatefulWidget {
  @override
  _WaterEffectState createState() => _WaterEffectState();
}

class _WaterEffectState extends State<WaterEffect> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            List<Offset> points1 = [];
            List<Offset> points2 = [];
            for(double i=0;i<=constraints.maxWidth;i++){
              double val = 15*sin(2*pi*(_animationController.value + (i/constraints.maxWidth)));
              double val2 = 15*sin(2*pi*(_animationController.value + (1-(i/constraints.maxWidth))));
              points1.add(Offset(i,constraints.maxWidth-15+val));
              points2.add(Offset(constraints.maxWidth - i,15+val2));
            }
            return ClipPath(
              clipper: WaveClipper(points1,points2),
                child: Container(
                constraints: constraints,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth,
                      color: Color.fromARGB(255, 0, 60, 192),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  List<Offset> offsets1;
  List<Offset> offsets2;
  WaveClipper(this.offsets1,this.offsets2);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(offsets1[0].dx,offsets1[0].dy);
    path.addPolygon(offsets1, false);
    path.lineTo(offsets2[0].dx,offsets2[0].dy);
    path.addPolygon(offsets2, false);
    path.lineTo(offsets2[offsets2.length-1].dx,offsets2[offsets2.length-1].dy);
    path.lineTo(offsets1[0].dx,offsets1[0].dy);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}