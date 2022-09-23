import 'dart:convert';
import 'dart:io';
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

postrssi(int data) async {
  Map data1 = {
    'RSSI1': data,
    'RSSI2': data - 1,
    'RSSI3': -57,
    'RSSI4': -57,
    'RSSI5': -57
  };
  String body = json.encode(data1);
  var response = await http.post(
      Uri.parse('https://223f-202-28-7-61.ap.ngrok.io/Sent_rssiwarut/posts'),
      headers: {"Content-Type": "application/json"},
      body: body);

  print(response.body);
  return response.body;
}
