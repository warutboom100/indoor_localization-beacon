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
  final Future<String> _calculation =
      Future<String>.delayed(const Duration(seconds: 5), () => 'Data Loaded');
  final formkey = GlobalKey<FormState>();
  Profile profile = Profile();
  int counter = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    /// Initialize a periodic timer with 1 second duration
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        /// callback will be executed every 1 second, increament a count value
        /// on each callback
        setState(() {
          counter + 2;
          postrssi(counter);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Container(
          width: 400,
          height: 400,
          child: CustomPaint(
            painter: OpenPainter(),
          ),
        ),
      ]),
    );
  }
}

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffaa44aa)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(50, 50), 10, paint1);
    canvas.drawCircle(Offset(350, 50), 10, paint1);
    canvas.drawCircle(Offset(350, 350), 10, paint1);
    canvas.drawCircle(Offset(50, 350), 10, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
