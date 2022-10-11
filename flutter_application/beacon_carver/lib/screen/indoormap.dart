import 'dart:async';
import 'dart:io';

import 'package:beacon_carver/model/profile.dart';
import 'package:beacon_carver/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class IndoormapScreen extends StatefulWidget {
  const IndoormapScreen({Key? key}) : super(key: key);

  @override
  _IndoormapScreen createState() => _IndoormapScreen();
}

class _IndoormapScreen extends State<IndoormapScreen> {
  double top = -350;
  double left = -400;
  double ratio = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: 800,
          height: 400,
          child: GestureDetector(
            onPanUpdate: _handlePanUpdate,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: top,
                    left: left,
                    width: 1200 * ratio,
                    child: Image.asset('assets/images/map1.png')),
                Positioned(
                  left: 0,
                  top: 50,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _handleZoomIn,
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _handleZoomOut,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    child: CustomPaint(
                  painter: OpenPainter(top, left),
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    // print('The top is $top');
    // print('The left is $left');
    setState(() {
      top = top + details.delta.dy;
      left = left + details.delta.dx;
    });
  }

  void _handleZoomIn() {
    setState(() {
      ratio *= 1.5;
    });
  }

  void _handleZoomOut() {
    setState(() {
      ratio /= 1.5;
    });
  }
}

class OpenPainter extends CustomPainter {
  double x = 0;
  double y = 0;

  OpenPainter(this.x, this.y);
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffaa44aa)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(250 + y + 350, 400 + x + 400), 10, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
