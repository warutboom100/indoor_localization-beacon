import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile {
  String? username;
  String? passward;

  Profile({this.username, this.passward});
}

Future<int> postData(String? username, String? password) async {
  try {
    Map data1 = {'deviceID': username};
    String body = json.encode(data1);
    var response = await http.post(
        Uri.parse('https://1eb4-58-10-4-143.ap.ngrok.io/reg_users'),
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
    String url = "https://1eb4-58-10-4-143.ap.ngrok.io/login_users/$username";
    var response = await http.get(Uri.parse(url));

    int counter = response.statusCode;
    return Future.value(counter);
  } on SocketException {
    return Future.value(200);
  }
}

postrssi(double data) async {
  Map data1 = {
    'RSSI1': data,
    'RSSI2': data - 1,
    'RSSI3': -57,
    'RSSI4': -57,
    'RSSI5': -57
  };
  String body = json.encode(data1);
  var response = await http.post(
      Uri.parse('https://a3720cc087b4.ap.ngrok.io/Sent_rssiwarut/posts'),
      headers: {"Content-Type": "application/json"},
      body: body);
  var decoded = json.decode(response.body);
  List result = [];
  decoded.values.forEach((value) {
    result.add(value);
  });

  return Future.value(result);
}

class MapObject {
  final Widget child;

  ///relative offset from the center of the map for this map object. From -1 to 1 in each dimension.
  final Offset offset;

  ///size of this object for the zoomLevel == 1
  final Size size;

  MapObject({
    required this.child,
    required this.offset,
    required this.size,
  });
}
