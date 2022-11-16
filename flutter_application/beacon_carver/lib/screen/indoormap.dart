import 'dart:async';
import 'dart:io';

import 'package:beacon_carver/ble/ble_data.dart';
import 'package:beacon_carver/model/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

final Color color2 = Color(0xffFA8165);

class IndoormapScreen extends StatefulWidget {
  const IndoormapScreen({Key? key}) : super(key: key);

  @override
  _IndoormapScreen createState() => _IndoormapScreen();
}

enum _Action { scale, pan }

const _defaultMarkerSize = 8.0;

class _IndoormapScreen extends State<IndoormapScreen>
    with SingleTickerProviderStateMixin {
  Offset _pos =
      Offset.zero; // Position could go from -1 to 1 in both directions
  _Action? action; // pan or pinch, useful to know if we need to scale down pin
  final _transformationController = TransformationController();
  final formkey = GlobalKey<FormState>();
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  late AnimationController controller;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Timer? timer;

  List<dynamic> pos = [0.0, 0.0];

  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();
    final bleController = Get.put(BLEResult());

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() => setState(() {}))
      ..forward()
      ..addStatusListener((status) async {
        List rssi1 = [0, 0];
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();

          for (int idx = 0;
              idx < bleController.selectedDistanceList.length;
              idx++) {
            var rssi = bleController
                .scanResultList[bleController.selectedDeviceIdxList[idx]].rssi;
            String id = bleController
                .scanResultList[bleController.selectedDeviceIdxList[idx]]
                .device
                .id
                .id;
            if (id == "DD:EE:07:58:61:32") {
              rssi1[0] = rssi;
            }
            if (id == "D3:B7:A7:91:0B:FC") {
              rssi1[1] = rssi;
            }
          }

          postrssi(rssi1);
        }
      });

    // timer = Timer.periodic(
    //   const Duration(milliseconds: 10),
    //   (timer)  {
    //     /// callback will be executed every 1 second, increament a count value
    //     /// on each callback

    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final size = _defaultMarkerSize / scale;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your position'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outlined),
            onPressed: () {
              showAlertDialog(context);
            },
          )
        ],
      ),
      body: InteractiveViewer(
        transformationController: _transformationController,
        maxScale: 5,
        minScale: 1,
        child: Stack(
          children: [
            Center(child: Image.asset('assets/images/map.png')),
            Positioned(
                child: CustomPaint(
              painter: OpenPainter(pos[0], pos[1], size),
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
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.info_outline),
      //   onPressed: () {
      //     // Navigator.pop(context);
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    timer?.cancel();
  }
}
//20.8 == 1m 208.9(x) , 24.6 == 1m 303.5(y)

class OpenPainter extends CustomPainter {
  double x = 0;
  double y = 0;

  static double x_old = 0;
  static double y_old = 0;
  final double a;
  OpenPainter(this.x, this.y, this.a);
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(206.4 - a, 301 - a, 211.4 + a, 306 + a);
    Rect rect1 = Rect.fromLTRB(206.4 - a, 424 - a, 211.4 + a, 429 + a);
    Rect rect2 = Rect.fromLTRB(310.4 - a, 301 - a, 315.4 + a, 306 + a);
    Rect rect3 = Rect.fromLTRB(310.4 - a, 424 - a, 315.4 + a, 429 + a);
    var paint1 = Paint()
      ..color = Color.fromARGB(255, 255, 23, 23)
      ..style = PaintingStyle.fill;
    var paint2 = Paint()
      ..color = Color.fromARGB(255, 37, 90, 216)
      ..style = PaintingStyle.fill;

    if (x >= -1 && x <= 6) {
      x_old = x;
    }
    if (y >= -1 && y <= 6) {
      y_old = y;
    }
    canvas.drawCircle(
        Offset((x_old * 20.8) + 206.4, (y_old * 24.6) + 301), a, paint2);
    canvas.drawRect(rect, paint1);
    canvas.drawRect(rect1, paint1);
    canvas.drawRect(rect2, paint1);
    canvas.drawRect(rect3, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
      title: Text("About"),
      content: Wrap(
        children: [
          Text(''),
          Row(
            children: [
              Image.asset('assets/images/rectangle-16.png'),
              SizedBox(width: 5),
              Text(' beacon'),
            ],
          ),
          Row(
            children: [
              Image.asset('assets/images/circle-16.png'),
              SizedBox(width: 5),
              Text(' now position '),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 5),
              Text('----------------------------------------'),
            ],
          ),
        ],
      ));

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
