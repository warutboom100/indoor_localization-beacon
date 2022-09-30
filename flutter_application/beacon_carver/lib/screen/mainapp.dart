import 'package:beacon_carver/ble/ble_data.dart';
import 'package:beacon_carver/screen/imu_view.dart';
import 'package:beacon_carver/screen/indoormap.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:rolling_switch/rolling_switch.dart';

class mainapp extends StatelessWidget {
  const mainapp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BLE indoor positioning',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const BLEProjectPage(title: 'BLE SCAN DEMO'),
    );
  }
}

/* First Page */
class BLEProjectPage extends StatefulWidget {
  const BLEProjectPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BLEProjectPage> createState() => _BLEProjectPageState();
}

class _BLEProjectPageState extends State<BLEProjectPage> {
  var bleController = Get.put(BLEResult());
  // page bleController
  int _currentBody = 0;
  final _pageController = PageController();
  TextEditingController textController = TextEditingController();

  // flutter_blue_plus
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  bool isScanning = false;
  int scanMode = 0;

  //BLEResult bleResult = BLEResult();

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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () {
            toggleState();
          },
        ),
        body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              isScanning ? pageBLEScan() : selectScanMode(),
              const IndoormapScreen(),
              imu_view(),
            ]),
        bottomNavigationBar: BottomBar(
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectedIndex: _currentBody,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentBody = index);
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: const Icon(Icons.bluetooth),
              title: const Text('BLE Scan'),
              activeColor: Colors.blue,
              activeTitleColor: Colors.blue.shade600,
            ),
            BottomBarItem(
              icon: const Icon(Icons.place),
              title: const Text('Indoor Map'),
              backgroundColorOpacity: 0.1,
              activeColor: Colors.redAccent.shade700,
            ),
            BottomBarItem(
              icon: const Icon(Icons.account_circle),
              title: const Text('Setting'),
              backgroundColorOpacity: 0.1,
              activeColor: Colors.greenAccent.shade700,
            ),
          ],
        ));
  }

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
          selectedBackgroundColors: const [Colors.blue, Colors.blueAccent],
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
  Widget widgetBLEList(int index, ScanResult r) {
    toStringBLE(r);

    bleController.updateBLEList(
        deviceName: deviceName,
        macAddress: macAddress,
        rssi: rssi,
        serviceUUID: serviceUUID,
        manuFactureData: manuFactureData,
        tp: tp);

    serviceUUID.isEmpty ? serviceUUID = 'null' : serviceUUID;
    manuFactureData.isEmpty ? manuFactureData = 'null' : manuFactureData;
    bool switchFlag = bleController.flagList[index];
    switchFlag ? deviceName = '$deviceName (active)' : deviceName;

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
}
