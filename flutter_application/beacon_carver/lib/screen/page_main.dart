import 'package:beacon_carver/screen/home.dart';
import 'package:beacon_carver/screen/indoormap.dart';
import 'package:beacon_carver/screen/user_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:beacon_carver/ble/ble_data.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

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

  static Icon fab = Icon(
    Icons.search,
  );

  static int fabIconNumber = 0;
  var bleController = Get.put(BLEResult());
  final _pageController = PageController();
  TextEditingController textController = TextEditingController();

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  static bool isScanning = false;
  int scanMode = 0;

  // BLE value
  String deviceName = '';
  String macAddress = '';
  String rssi = '';
  String serviceUUID = '';
  String manuFactureData = '';
  String tp = '';

  var _tabScanModeIndex = 1;
  final _scanModeList = ['Low Power', 'Balanced', 'Performance'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your position'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    toggleState();
                    setState(() {
                      if (fabIconNumber == 0) {
                        fab = Icon(
                          Icons.stop,
                        );
                        fabIconNumber = 1;
                      } else {
                        fab = Icon(Icons.search);
                        fabIconNumber = 0;
                      }
                    });
                  },
                  child: fab)),
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
              title: const Text('Profile'),
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return User_position();
                  }));
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return IndoormapScreen();
          }));
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
    if (macAddress == "DD:EE:07:58:61:32" ||
        macAddress == "F3:66:AB:6E:ED:36" ||
        macAddress == "C8:EC:06:1D:7B:DF" ||
        macAddress == "DF:0E:44:8D:32:C1") {
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
  }

  Container _buildHeader() {
    return Container(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: -100,
            top: -150,
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color1, color2]),
                  boxShadow: [
                    BoxShadow(
                        color: color2,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0)
                  ]),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [color3, color2]),
                boxShadow: [
                  BoxShadow(
                      color: color3, offset: Offset(1.0, 1.0), blurRadius: 4.0)
                ]),
          ),
          Positioned(
            top: 100,
            right: 200,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color3, color2]),
                  boxShadow: [
                    BoxShadow(
                        color: color3,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0)
                  ]),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Himanshu",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10.0),
                Text(
                  "You have 2 remaining\ntasks for today!",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /* Selected BLE Scan Page */
  Center pageBLESelected() => Center(
        child:
            /* listview */
            ListView.separated(
                itemCount: bleController.selectedDeviceIdxList.length,
                itemBuilder: (context, index) => widgetSelectedBLEList(
                      index,
                      bleController.scanResultList[
                          bleController.selectedDeviceIdxList[index]],
                    ),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider()),
      );

  /* listview widget for ble data */
  Widget widgetSelectedBLEList(int currentIdx, ScanResult r) {
    toStringBLE(r);
    bleController.updateBLEList(
        deviceName: deviceName,
        macAddress: macAddress,
        rssi: rssi,
        serviceUUID: serviceUUID,
        manuFactureData: manuFactureData,
        tp: tp);

    num distance = 5;

    bleController.selectedDistanceList[currentIdx] = distance;
    String constN = bleController.selectedConstNList[currentIdx].toString();
    String rssi1m = bleController.selectedRSSI_1mList[currentIdx].toString();

    return ExpansionTile(
      //leading: leading(r),
      title: Text('$deviceName ($macAddress)',
          style: const TextStyle(color: Colors.black)),
      subtitle: Text(
          '\n Alias : Anchor$currentIdx\n N : $constN\n RSSI at 1m : ${rssi1m}dBm',
          style: const TextStyle(color: Colors.blueAccent)),
      trailing: Text('${distance.toStringAsPrecision(3)}m',
          style: const TextStyle(color: Colors.black)),
    );
  }
}
