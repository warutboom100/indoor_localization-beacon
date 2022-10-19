import 'dart:async';
import 'dart:io';

import 'package:beacon_carver/model/profile.dart';
import 'package:beacon_carver/screen/home.dart';
import 'package:beacon_carver/screen/page_main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

final Color color2 = Color(0xffFA8165);

class IndoormapScreen extends StatefulWidget {
  const IndoormapScreen({Key? key}) : super(key: key);

  @override
  _IndoormapScreen createState() => _IndoormapScreen();
}

double pos_x = 100;

enum _Action { scale, pan }

const _defaultMarkerSize = 8.0;

class _IndoormapScreen extends State<IndoormapScreen> {
  Offset _pos =
      Offset.zero; // Position could go from -1 to 1 in both directions
  _Action? action; // pan or pinch, useful to know if we need to scale down pin
  final _transformationController = TransformationController();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    /// Initialize a periodic timer with 1 second duration
    timer = Timer.periodic(
      const Duration(milliseconds: 700),
      (timer) {
        setState(() {
          pos_x += 5;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final size = _defaultMarkerSize / scale;
    return Scaffold(
      appBar: AppBar(title: Text('Your position')),
      body: InteractiveViewer(
        transformationController: _transformationController,
        maxScale: 5,
        minScale: 1,
        child: Stack(
          children: [
            Center(child: Image.asset('assets/images/map.png')),
            Positioned(
                child: CustomPaint(
              painter: OpenPainter(pos_x, 353, size),
            ))
          ],
        ),
        onInteractionStart: (details) {
          // No need to call setState as we don't need to rebuild
          action = null;
        },
        onInteractionUpdate: (details) {
          if (action == null) {
            if (details.scale == 1)
              action = _Action.pan;
            else
              action = _Action.scale;
          }
          if (action == _Action.scale) {
            // Need to resize the pins so that they keep the same size
            setState(() {});
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.keyboard_return),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    timer?.cancel();
  }
}

class OpenPainter extends CustomPainter {
  double x = 0;
  double y = 0;
  final double a;
  OpenPainter(this.x, this.y, this.a);
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffaa44aa)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), a, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
