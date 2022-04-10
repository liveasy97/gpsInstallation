// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/models/traccerDataModel.dart';
import 'package:gpsinstallation/models/truckDataModel.dart';
import 'package:gpsinstallation/screens/powerCheckTwo.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PowerCheckOne extends StatefulWidget {
  int taskId;
  String vehicleNo;
  String driverName;
  String driverPhoneNo;
  String vehicleOwnerName;
  String vehicleOwnerPhoneNo;
  PowerCheckOne(
      {required this.vehicleNo,
      required this.driverName,
      required this.driverPhoneNo,
      required this.vehicleOwnerName,
      required this.vehicleOwnerPhoneNo,
      required this.taskId});

  @override
  State<PowerCheckOne> createState() => _PowerCheckOneState();
}

class _PowerCheckOneState extends State<PowerCheckOne> {
  String traccarApi = FlutterConfig.get("traccarApi");

  String traccarUser = FlutterConfig.get("traccarUser");
  String traccarPass = FlutterConfig.get("traccarPass");

  late TruckDataModel _truckDataModel;

  late List<TraccarDataModel> _traccarDataModel;
  String deviceId = "Unknown";
  String ignitionStatus = "Unknown";
  bool successLoading = false;

  Future<void> callApiGetDeviceId() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
    var url = Uri.parse(traccarApi + "/devices?uniqueId=" + MyApp.imei);
    var response = await http
        .get(url, headers: <String, String>{'authorization': basicAuth});
    var body = response.body;
    print("Called here as well" + body.toString());
    _truckDataModel = TruckDataModel.fromJson(jsonDecode(body));
    deviceId = _truckDataModel.id.toString();
    print(deviceId + "DEVICE IIID");
    callApiGetStatus();
    setState(() {});
  }

  Future<void> callApiGetStatus() async {
    final prefs = await SharedPreferences.getInstance();

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
    var url = Uri.parse(traccarApi + "/positions?deviceId=" + deviceId);

    var response = await http
        .get(url, headers: <String, String>{'authorization': basicAuth});
    var body = response.body;

    List<dynamic> parsedListJson = jsonDecode(body);
    _traccarDataModel = List<TraccarDataModel>.from(
        parsedListJson.map((i) => TraccarDataModel.fromJson(i)));
    print("IGNITION STATUS IS" +
        _traccarDataModel[0].attributes!.ignition!.toString());
    successLoading = true;

    TaskFetcher.dataForEachTask[widget.taskId].powerOneStatus = 2;
    await prefs.setInt(widget.vehicleNo.toString() + '_2', 2);

    TaskFetcher.dataForEachTask[widget.taskId].powerTwoStatus = 1;
    await prefs.setInt(widget.vehicleNo.toString() + '_3', 1);

    MyApp.latitude = _traccarDataModel[0].latitude!;
    MyApp.longitude = _traccarDataModel[0].longitude!;
    if (_traccarDataModel[0].attributes!.ignition!) {
      ignitionStatus = "On";
      setState(() {});
    } else {
      ignitionStatus = "Off";
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print("CALLED HERE");
    callApiGetDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Liveasy GPS Installer",
              style:
                  TextStyle(color: darkBlueColor, fontWeight: FontWeight.w700),
            ),
            elevation: 0,
            backgroundColor: Color(0xFFF0F0F0),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Image.asset(
                  "assets/icons/drawerIcon.png",
                  width: 24.0,
                  height: 24.0,
                ),
                // onPressed: () => Scaffold.of(context).openDrawer(),
                onPressed: () => {}),
          ),
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Power check 1',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(
                        height: 32,
                      ),
                      Image.asset(
                        'assets/icons/ignitioncheck.png',
                        fit: BoxFit.contain,
                        height: height / 6,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Flexible(
                          child: RichText(
                        text: const TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Task: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF152968),
                                    fontFamily: "montserrat")),
                            TextSpan(
                                text: "Ignition",
                                style: TextStyle(
                                    fontFamily: "montserrat", fontSize: 14)),
                            TextSpan(
                                text: ' OFF ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "montserrat")),
                            TextSpan(
                                text: "Kren",
                                style: TextStyle(fontFamily: "montserrat"))
                          ],
                        ),
                      )),
                      const SizedBox(
                        height: 32,
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text('Ignition status',
                                      style: TextStyle(fontSize: 10)),
                                  getFieldText(1),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text('Battery status',
                                      style: TextStyle(fontSize: 10)),
                                  getFieldText(2),
                                ],
                              ),
                            ],
                          ),
                        ),
                        elevation: 4,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: getNavMenu(),
                      )
                    ],
                  )))),
      onWillPop: () {
        Get.to(StepsView(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        return Future.value(true); // if true allow back else block it
      },
    );
  }

  Row getNavMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () => Get.back(),
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Back",
                style: TextStyle(color: darkBlueColor),
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: darkBlueColor))))),
        Text('Step 2 of 7', style: const TextStyle(fontSize: 12)),
        ElevatedButton(
            onPressed: () => {
                  if (successLoading)
                    {
                      Get.to(PowerCheckTwo(
                        taskId: widget.taskId,
                        driverName: widget.driverName,
                        driverPhoneNo: widget.driverPhoneNo,
                        vehicleNo: widget.vehicleNo,
                        vehicleOwnerName: widget.vehicleOwnerName,
                        vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
                      ))
                    }
                },
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Next",
                style: TextStyle(color: white),
              ),
            ),
            style: ButtonStyle(
                backgroundColor: (successLoading)
                    ? MaterialStateProperty.all<Color>(darkBlueColor)
                    : MaterialStateProperty.all<Color>(grey),
                shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: (successLoading)
                            ? BorderSide(color: darkBlueColor)
                            : BorderSide(color: grey))))),
      ],
    );
  }

  Row getFieldText(int textType) {
    String textHere = "Unknown";
    switch (textType) {
      case 1:
        textHere = "OFF";
        break;
      case 2:
        textHere = "Unknown";
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Text(
          textHere,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(
          width: 2,
        ),
        if (textType == 1)
          Icon(
              (successLoading)
                  ? Icons.check_circle
                  : FontAwesomeIcons.exclamationCircle,
              color: (successLoading) ? Colors.green : Colors.red,
              size: 12),
        if (textType == 2)
          Icon(FontAwesomeIcons.exclamationCircle, color: Colors.red, size: 12),
      ],
    );
  }
}
