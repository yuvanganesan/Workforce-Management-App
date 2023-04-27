import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
      child: ClipPath(
        clipper: CustomClipPath(),
        child: Container(
          height: height * .4,
          color: Colors.purple,
        ),
      ),
    ));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  // @override
  // Path getClip(Size size) {
  //   double w = size.width;
  //   double h = size.height;
  //   final path = Path();

  //   path.lineTo(0, h);
  //   path.quadraticBezierTo(w * .5, h - 100, w, h);
  //   path.lineTo(w, 0);
  //   path.close();
  //   return path;
  // }

  @override
  Path getClip(Size size) {
    Path path = Path();
    // final double _xScaling = size.width / 414;
    // final double _yScaling = size.height / 500; //896;
    // path.lineTo(0 * _xScaling, 0 * _yScaling);
    // path.cubicTo(
    //   0 * _xScaling,
    //   0 * _yScaling,
    //   430 * _xScaling,
    //   0 * _yScaling,
    //   430 * _xScaling,
    //   0 * _yScaling,
    // );
    // path.cubicTo(
    //   430 * _xScaling,
    //   0 * _yScaling,
    //   430 * _xScaling,
    //   246 * _yScaling,
    //   430 * _xScaling,
    //   246 * _yScaling,
    // );
    // path.cubicTo(
    //   430 * _xScaling,
    //   301.228 * _yScaling,
    //   385.228 * _xScaling,
    //   346 * _yScaling,
    //   330 * _xScaling,
    //   346 * _yScaling,
    // );
    // path.cubicTo(
    //   330 * _xScaling,
    //   346 * _yScaling,
    //   214 * _xScaling,
    //   346 * _yScaling,
    //   214 * _xScaling,
    //   346 * _yScaling,
    // );
    // path.cubicTo(
    //   214 * _xScaling,
    //   346 * _yScaling,
    //   94 * _xScaling,
    //   348.5 * _yScaling,
    //   94 * _xScaling,
    //   348.5 * _yScaling,
    // );
    // path.cubicTo(
    //   94 * _xScaling,
    //   348.5 * _yScaling,
    //   77.5 * _xScaling,
    //   351.5 * _yScaling,
    //   77.5 * _xScaling,
    //   351.5 * _yScaling,
    // );
    // path.cubicTo(
    //   77.5 * _xScaling,
    //   351.5 * _yScaling,
    //   69.5 * _xScaling,
    //   354.25 * _yScaling,
    //   69.5 * _xScaling,
    //   354.25 * _yScaling,
    // );
    // path.cubicTo(
    //   69.5 * _xScaling,
    //   354.25 * _yScaling,
    //   62 * _xScaling,
    //   357.5 * _yScaling,
    //   62 * _xScaling,
    //   357.5 * _yScaling,
    // );
    // path.cubicTo(
    //   62 * _xScaling,
    //   357.5 * _yScaling,
    //   47.5 * _xScaling,
    //   365.5 * _yScaling,
    //   47.5 * _xScaling,
    //   365.5 * _yScaling,
    // );
    // path.cubicTo(
    //   47.5 * _xScaling,
    //   365.5 * _yScaling,
    //   33 * _xScaling,
    //   377 * _yScaling,
    //   33 * _xScaling,
    //   377 * _yScaling,
    // );
    // path.cubicTo(
    //   33 * _xScaling,
    //   377 * _yScaling,
    //   21.5 * _xScaling,
    //   390 * _yScaling,
    //   21.5 * _xScaling,
    //   390 * _yScaling,
    // );
    // path.cubicTo(
    //   21.5 * _xScaling,
    //   390 * _yScaling,
    //   12 * _xScaling,
    //   405.5 * _yScaling,
    //   12 * _xScaling,
    //   405.5 * _yScaling,
    // );
    // path.cubicTo(
    //   12 * _xScaling,
    //   405.5 * _yScaling,
    //   5.5 * _xScaling,
    //   421 * _yScaling,
    //   5.5 * _xScaling,
    //   421 * _yScaling,
    // );
    // path.cubicTo(
    //   5.5 * _xScaling,
    //   421 * _yScaling,
    //   0 * _xScaling,
    //   441 * _yScaling,
    //   0 * _xScaling,
    //   441 * _yScaling,
    // );
    // path.cubicTo(
    //   0 * _xScaling,
    //   441 * _yScaling,
    //   0 * _xScaling,
    //   0 * _yScaling,
    //   0 * _xScaling,
    //   0 * _yScaling,
    // );
    // path.cubicTo(
    //   0 * _xScaling,
    //   0 * _yScaling,
    //   0 * _xScaling,
    //   0 * _yScaling,
    //   0 * _xScaling,
    //   0 * _yScaling,
    // );

    // path.lineTo(0, size.height);
    // path.quadraticBezierTo(
    //     size.width / 40, size.height - 100, size.width / 1.5, size.height - 70);
    // path.quadraticBezierTo(size.width - (size.width / 40), size.height - 170,
    //     size.width / 1, size.height - 140);
    // path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    // path.lineTo(size.width / 7, size.height - (size.height / 10));
    path.quadraticBezierTo(size.width / 50, size.height - (size.height / 5),
        size.width - (size.width * .7), size.height - (size.height / 5));
    // path.lineTo(
    //     size.width - (size.width / 7), size.height - (size.height / 10));
    //path.lineTo(size.width, size.height - (2 * (size.height / 5)));

    path.quadraticBezierTo(
        size.width - (size.width / 50),
        size.height - (size.height / 5),
        size.width,
        size.height - ((size.height / 2.5)));
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
