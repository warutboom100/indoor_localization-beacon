import 'package:beacon_carver/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:beacon_carver/screen/home.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LOGIN DEVICE ID"),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: formKey,
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
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState?.save();
                            print(
                                "username = ${profile.username} password = ${profile.passward}");

                            formKey.currentState?.reset();
                            Fluttertoast.showToast(
                                msg: "LOGIN Complete",
                                gravity: ToastGravity.CENTER);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return HomeScreen();
                            }));
                          }
                        },
                      ),
                    )
                  ],
                ))),
          ),
        ));
  }
}
