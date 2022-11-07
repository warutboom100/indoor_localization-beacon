import 'package:beacon_carver/model/profile.dart';
import 'package:beacon_carver/screen/page_main.dart';
import 'package:flutter/material.dart';
import 'package:beacon_carver/screen/login.dart';
import 'package:beacon_carver/screen/register.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:beacon_carver/screen/mainapp.dart';

class HomeScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff28c76f), Color(0xff130cb7)])),
          child: Form(
            key: formKey,
            child: ListView(children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 1, top: 50, right: 1, bottom: 1),
                child: new Text("SIgn in to Your Account",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )),
              ),
              new Padding(
                  padding:
                      EdgeInsets.only(left: 1, top: 50, right: 1, bottom: 1),
                  child: new Column(children: [
                    Image.asset('assets/images/indoor.png'),
                  ])),
              new Padding(
                padding: EdgeInsets.only(left: 1, top: 50, right: 1, bottom: 1),
                child: new Text("Beacons\nIndoor Localization Application",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )),
              ),
              new Padding(
                padding:
                    EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 1),
                child: new TextFormField(
                  style: new TextStyle(fontFamily: "Open Sans"),
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator:
                      RequiredValidator(errorText: 'Please Enter Username'),
                  keyboardType: TextInputType.text,
                  onSaved: (String? username) {
                    profile.username = username;
                  },
                ),
              ),
              new Padding(
                padding:
                    EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 1),
                child: new TextFormField(
                  style: new TextStyle(fontFamily: "Open Sans"),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator:
                      RequiredValidator(errorText: 'Please Enter Password'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
              ),
              new Padding(
                padding:
                    EdgeInsets.only(left: 20, top: 25, right: 20, bottom: 1),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          int error = await getRequest(profile.username);
                          if (error != 200) {
                            Fluttertoast.showToast(
                                msg: "Sorry this user does not exist",
                                gravity: ToastGravity.CENTER);
                          } else {
                            Profile.name = profile.username!;
                            Fluttertoast.showToast(
                                msg: "LOGIN Complete",
                                gravity: ToastGravity.CENTER);
                            formKey.currentState?.reset();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return Homepage_app();
                            }));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white70,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.login),
                      label: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 85, top: 25, right: 85, bottom: 1),
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  child: Wrap(
                    children: [
                      const Text('Don’t have an account? '),
                      GestureDetector(
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RegisterScreen();
                          }));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
