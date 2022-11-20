import 'dart:convert';

import 'package:beacon_carver/model/profile.dart';
import 'package:beacon_carver/screen/page_main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final Color color2 = Color(0xffFA8165);

class User_position extends StatefulWidget {
  const User_position({Key? key}) : super(key: key);

  @override
  _User_position createState() => _User_position();
}

class _User_position extends State<User_position> {
  List data = [];
  double x = 0;
  double y = 0;
  String userdata = Profile.name;
  Future<String> getData() async {
    var response = await http.get(
      Uri.parse(
          'https://b2279e996680.ap.ngrok.io/gets_position$userdata?skip=0&limit=10'),
      headers: {"Content-Type": "application/json"},
    );

    this.setState(() {
      data = json.decode(response.body);
    });

    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Location History"), backgroundColor: Colors.blue),
      body: new Center(
        child: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            x = data[index]["position_x"];
            y = data[index]["position_y"];
            return new Card(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 32, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
                            child: new Text(
                              'Position( $x , $y )',
                              //'Note Title',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                          new Text(
                            data[index]["owner_id"],
                            //'Note Text',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/images/Logo.png'),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
