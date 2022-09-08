import 'package:flutter/material.dart';
import 'package:beacon_carver/screen/login.dart';
import 'package:beacon_carver/screen/register.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF02021A), Color(0xFF072F71)])),
      ),
    );
  }
}
