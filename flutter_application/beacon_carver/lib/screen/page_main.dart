import 'package:beacon_carver/model/kalmanfilter.dart';
import 'package:beacon_carver/model/profile.dart';
import 'package:beacon_carver/screen/home.dart';
import 'package:beacon_carver/screen/imu_view.dart';
import 'package:beacon_carver/screen/indoormap.dart';
import 'package:beacon_carver/screen/user_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:beacon_carver/ble/ble_data.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

KalmanFilter kf = new KalmanFilter(0.0075, 2.182, 0, 0);
KalmanFilter kf1 = new KalmanFilter(0.0075, 2.182, 0, 0);
KalmanFilter kf2 = new KalmanFilter(0.0075, 2.182, 0, 0);
KalmanFilter kf3 = new KalmanFilter(0.0075, 2.182, 0, 0);

class Homepage_app extends StatefulWidget {
  const Homepage_app({Key? key}) : super(key: key);

  @override
  _Homepage_app createState() => _Homepage_app();
}

class _Homepage_app extends State<Homepage_app> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);
  final List tasks = [
    {
      "title": "Buy computer science book from Agarwal book store",
      "completed": true
    },
    {"title": "Send updated logo and source files", "completed": false},
    {"title": "Recharge broadband bill", "completed": false},
    {"title": "Pay telephone bill", "completed": false},
  ];

  var bleController = Get.put(BLEResult());
  final _pageController = PageController();
  TextEditingController textController = TextEditingController();

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  bool isScanning = false;
  int scanMode = 0;

  // BLE value
  String deviceName = '';
  String macAddress = '';
  String rssi = '';
  String serviceUUID = '';
  String manuFactureData = '';
  String tp = '';

  String userdata = Profile.name;

  var _tabScanModeIndex = 1;
  final _scanModeList = ['Low Power', 'Balanced', 'Performance'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localization'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.search),
            onPressed: () {
              toggleState();
            },
          )
        ],
      ),
      key: _key,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                  color: color1,
                  image: DecorationImage(
                      image: AssetImage("assets/images/Logo.png"),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Profile ($userdata) '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: const Text('Setting'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: const Text('Sign out '),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                }));
              },
            ),
          ],
        ),
      ),
      body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            isScanning ? pageBLEScan() : selectScanMode(),
          ]),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: color1,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  }),
              Spacer(),
              IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.map,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const imu_view()),
                  );
                },
              ),
              SizedBox(width: 20.0),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: color3,
        child: Icon(Icons.place),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IndoormapScreen()),
          );
        },
      ),
    );
  }

  Center selectScanMode() => Center(
          child: Column(children: <Widget>[
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(),
            TextAnimator(
              'Beacon Scan Mode',
              atRestEffect: WidgetRestingEffects.pulse(effectStrength: 0.25),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(8)),
        FlutterToggleTab(
          width: 90,
          borderRadius: 30,
          height: 50,
          selectedIndex: _tabScanModeIndex,
          selectedBackgroundColors: const [Colors.red, Colors.redAccent],
          selectedTextStyle: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          unSelectedTextStyle: const TextStyle(
              color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
          labels: _scanModeList,
          selectedLabelIndex: (index) {
            setState(() {
              _tabScanModeIndex = scanMode = index;
            });
          },
          isScroll: false,
        ),
        const Spacer(),
      ]));
  Center pageBLEScan() => Center(
        child:
            /* listview */
            ListView.separated(
                itemCount: bleController.scanResultList.length,
                itemBuilder: (context, index) =>
                    widgetBLEList(index, bleController.scanResultList[index]),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider()),
      );
  Widget widgetBLEList(int index, ScanResult r) {
    toStringBLE(r);

    bleController.updateBLEList(
        deviceName: deviceName,
        macAddress: macAddress,
        rssi: rssi,
        serviceUUID: serviceUUID,
        manuFactureData: manuFactureData,
        tp: tp);
    if (macAddress == "D3:B7:A7:91:0B:FC" ||
        macAddress == "EF:43:DF:C2:9D:7B" ||
        macAddress == "DF:0E:44:8D:32:C1" ||
        macAddress == "DD:EE:07:58:61:32") {
      bleController.flagList[index];
      bleController.updateFlagList(flag: true, index: index);
    }
    serviceUUID.isEmpty ? serviceUUID = 'null' : serviceUUID;
    manuFactureData.isEmpty ? manuFactureData = 'null' : manuFactureData;
    bool switchFlag = bleController.flagList[index];
    switchFlag ? deviceName = '$deviceName (beacon)' : deviceName;

    bleController.updateselectedDeviceIdxList();

    return ExpansionTile(
      leading: leading(r),
      title: Text(deviceName,
          style:
              TextStyle(color: switchFlag ? Colors.lightBlue : Colors.black)),
      subtitle: Text(macAddress,
          style:
              TextStyle(color: switchFlag ? Colors.lightBlue : Colors.black)),
      trailing: Text(rssi,
          style:
              TextStyle(color: switchFlag ? Colors.lightBlue : Colors.black)),
      children: <Widget>[
        ListTile(
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'UUID : $serviceUUID\nManufacture data : $manuFactureData\nTX power : ${tp == 'null' ? tp : '${tp}dBm'}',
                  style: const TextStyle(fontSize: 10),
                ),
              ]),
        )
      ],
    );
  }

  void toggleState() {
    isScanning = !isScanning;
    if (isScanning) {
      flutterBlue.startScan(
          scanMode: ScanMode(scanMode), allowDuplicates: true);
      scan();
    } else {
      flutterBlue.stopScan();
      bleController.initBLEList();
    }
    setState(() {});
  }

  void scan() async {
    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      bleController.scanResultList = results;
      // update state
      setState(() {});
    });
  }

  Widget leading(ScanResult r) => const CircleAvatar(
        backgroundColor: Colors.cyan,
        child: Icon(
          Icons.bluetooth,
          color: Colors.white,
        ),
      );
  String deviceNameCheck(ScanResult r) {
    String name;

    if (r.device.name.isNotEmpty) {
      // Is device.name
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // Is advertisementData.localName
      name = r.advertisementData.localName;
    } else {
      // null
      name = 'N/A';
    }
    return name;
  }

  void toStringBLE(ScanResult r) {
    deviceName = deviceNameCheck(r);
    macAddress = r.device.id.id;

    serviceUUID = r.advertisementData.serviceUuids
        .toString()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
    manuFactureData = r.advertisementData.manufacturerData
        .toString()
        .replaceAll('{', '')
        .replaceAll('}', '');
    tp = r.advertisementData.txPowerLevel.toString();
    rssi = r.rssi.toString();
    // if (macAddress == "DD:EE:07:58:61:32") {
    //   rssi = kf.getFilteredValue(r.rssi.toDouble()).toString();
    // }
    // if (macAddress == "D3:B7:A7:91:0B:FC") {
    //   rssi = kf1.getFilteredValue(r.rssi.toDouble()).toString();
    // }
    // if (macAddress == "C8:EC:06:1D:7B:DF") {
    //   rssi = kf2.getFilteredValue(r.rssi.toDouble()).toString();
    // }
    // if (macAddress == "DF:0E:44:8D:32:C1") {
    //   rssi = kf3.getFilteredValue(r.rssi.toDouble()).toString();
    // }
  }
}
