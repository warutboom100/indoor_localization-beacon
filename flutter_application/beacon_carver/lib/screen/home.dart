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
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.0),
          body: SafeArea(
              child: Column(
            children: [
              Container(
                child: SizedBox(height: 40),
              ),
              Container(
                  child: Column(children: [
                Image.asset('assets/images/Logo.png'),
              ])),
              Container(
                width: 320,
                margin: EdgeInsets.fromLTRB(16, 150, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegisterScreen();
                        }));
                      },
                      icon: Icon(Icons.add),
                      label: Text(
                        "Register",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              ),
              Container(
                width: 320,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      icon: Icon(Icons.login),
                      label: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
