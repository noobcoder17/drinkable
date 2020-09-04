import 'package:flutter/material.dart';

class ThreeLayerBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: constraints.maxHeight,
                  color: Color.fromARGB(255,11, 209, 252),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: constraints.maxHeight*0.75,
                  color: Color.fromARGB(255, 0, 140, 238),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: constraints.maxHeight*0.50,
                  color: Color.fromARGB(255, 0, 60, 192),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0,size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 30);
    path.quadraticBezierTo(size.width/2, -1, 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}