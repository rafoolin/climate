import 'package:flutter/material.dart';

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double unit = size.width / 9;
    double height = size.height;
    Offset startPoint = Offset(0.0, height - 10);
    Offset endPoint = Offset(size.width, startPoint.dy - 15);
    double r1 = 10;
    double r2 = 10;
    double r3 = 50;

    path.lineTo(startPoint.dx, startPoint.dy);

    path.quadraticBezierTo(
      unit,
      startPoint.dy - r1,
      2 * unit,
      startPoint.dy,
    );
    path.quadraticBezierTo(
      3 * unit,
      startPoint.dy + r2,
      4 * unit,
      startPoint.dy - 5,
    );
    path.quadraticBezierTo(
      6.5 * unit,
      startPoint.dy - r3,
      8 * unit,
      startPoint.dy - 20,
    );
    path.quadraticBezierTo(
      8.5 * unit,
      endPoint.dy,
      endPoint.dx,
      endPoint.dy - 5,
    );
    path.lineTo(endPoint.dx, endPoint.dy);
    path.lineTo(endPoint.dx, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
