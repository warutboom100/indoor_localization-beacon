import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile {
  String? username;
  String? passward;
  static var name = '';
  Profile({
    this.username,
    this.passward,
  });
}

Future<int> postData(String? username, String? password) async {
  try {
    Map data1 = {'deviceID': username};
    String body = json.encode(data1);
    var response = await http.post(
        Uri.parse('https://0e5acab8c700.ap.ngrok.io/reg_users'),
        headers: {"Content-Type": "application/json"},
        body: body);
    int counter = response.statusCode;
    return Future.value(counter);
  } on SocketException {
    print('No Internet connection 😑');
    return Future.value(200);
  }
}

Future<int> getRequest(String? username) async {
  try {
    String url = "https://0e5acab8c700.ap.ngrok.io/login_users/$username";
    var response = await http.get(Uri.parse(url));

    int counter = response.statusCode;
    return Future.value(counter);
  } on SocketException {
    return Future.value(200);
  }
}

postrssi(List data) async {
  String userdata = Profile.name;
  Map data1 = {
    'RSSI1': data[0],
    'RSSI2': -57,
    'RSSI3': -57,
    'RSSI4': -57,
    'RSSI5': -57
  };
  String body = json.encode(data1);
  var response = await http.post(
      Uri.parse('https://0e5acab8c700.ap.ngrok.io/Sent_rssi$userdata/posts'),
      headers: {"Content-Type": "application/json"},
      body: body);
  var decoded = json.decode(response.body);
  List result = [];
  decoded.values.forEach((value) {
    result.add(value);
  });

  return Future.value(result);
}
