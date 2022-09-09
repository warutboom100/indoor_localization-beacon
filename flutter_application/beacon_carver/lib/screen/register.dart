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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("REGISTER DEVICE ID"),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
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
                      validator:
                          RequiredValidator(errorText: 'Please Enter Username'),
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
                      validator:
                          RequiredValidator(errorText: 'Please Enter Password'),
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
                                Fluttertoast.showToast(
                                    msg: "Username is in use",
                                    gravity: ToastGravity.CENTER);
                              } else {
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
