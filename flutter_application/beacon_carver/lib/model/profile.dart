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
        Uri.parse('https://0f75-58-10-4-143.ap.ngrok.io/reg_users'),
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
    String url = "https://0f75-58-10-4-143.ap.ngrok.io/login_users/$username";
    var response = await http.get(Uri.parse(url));

    int counter = response.statusCode;
    return Future.value(counter);
  } on SocketException {
    return Future.value(200);
  }
}
