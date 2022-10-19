import 'dart:io';

import 'package:beacon_carver/model/profile.dart';
import 'package:beacon_carver/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formkey = GlobalKey<FormState>();
  Profile profile = Profile();

  bool _loading = false;

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(seconds: 3), _login);
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.. wait...",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("REGISTER DEVICE ID"),
        ),
        body: new Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _loading
                ? bodyProgress
                : Form(
                    key: formkey,
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: 'Please Enter Username'),
                          keyboardType: TextInputType.text,
                          onSaved: (String? username) {
                            profile.username = username;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: 'Please Enter Password'),
                          obscureText: true,
                          onSaved: (String? password) {
                            profile.passward = password;
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              child: Text('ENTER'),
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState?.save();
                                  int error = await postData(
                                      profile.username, profile.passward);

                                  if (error != 200) {
                                    _onLoading();
                                    Fluttertoast.showToast(
                                        msg: "Username is in use",
                                        gravity: ToastGravity.CENTER);
                                  } else {
                                    _onLoading();
                                    Fluttertoast.showToast(
                                        msg: "Register Complete",
                                        gravity: ToastGravity.CENTER);
                                    formkey.currentState?.reset();
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomeScreen();
                                    }));
                                  }
                                }
                              }),
                        )
                      ],
                    ))),
          ),
        ));
  }
}
