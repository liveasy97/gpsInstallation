// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/functions/truckLockApiCalls.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/models/traccerDataModel.dart';
import 'package:gpsinstallation/models/truckDataModel.dart';
import 'package:gpsinstallation/screens/relayCheckTwo.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';
import 'package:gpsinstallation/widgets/drawerWidget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:flutter/scheduler.dart';

class RelayCheckOne extends StatefulWidget {
  int taskId;
  String vehicleNo;
  String driverName;
  String driverPhoneNo;
  String vehicleOwnerName;
  String vehicleOwnerPhoneNo;
  RelayCheckOne(
      {required this.vehicleNo,
      required this.driverName,
      required this.driverPhoneNo,
      required this.vehicleOwnerName,
      required this.vehicleOwnerPhoneNo,
      required this.taskId});

  @override
  State<RelayCheckOne> createState() => _RelayCheckOneState();
}

class _RelayCheckOneState extends State<RelayCheckOne>
    with SingleTickerProviderStateMixin {
  String traccarApi = FlutterConfig.get("traccarApi");

  String traccarUser = FlutterConfig.get("traccarUser");
  String traccarPass = FlutterConfig.get("traccarPass");

  late TruckDataModel _truckDataModel;

  late List<TraccarDataModel> _traccarDataModel;
  String deviceId = "Unknown";
  String ignitionStatus = "Unknown";
  bool successLoading = false;
  late TimerController _timerController;
  Future<void> sendLockApi() async {
    EasyLoading.show(status: 'Loading...');

    final prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString("deviceId")!;
    await postCommandsApi(int.parse(deviceId), "engineStop", "sendingLock")
        .then((uploadstatus) async {
      if (uploadstatus == "Success") {
        print("SENT LOCK TO DEVICE");
        getCommandsResult();
        lockStorage.write('lockState', false);
      } else {
        print("PROBLEM IN SENDING TO DEVICE $deviceId");
      }
    });
    EasyLoading.dismiss();
    setState(() {});
  }

  Future<void> getCommandsResult() async {
    EasyLoading.show(status: 'Loading...');

    var timeNow = DateTime.now()
        .subtract(Duration(hours: 5, minutes: 30))
        .toIso8601String();
    getCommandsResultApi(int.parse(deviceId), timeNow);

    Timer(Duration(seconds: 15), () {
      getCommandsResultApi(int.parse(deviceId), timeNow).then((lockStatus) {
        if (lockStatus == "lock") {
          print("THE COMMAND WENT PROPERLY");
          setState(() {
            successLoading = true;
            lockStorage.write('lockState', false);
            lockUnlockController.lockUnlockStatus.value = false;
            lockUnlockController.updateLockUnlockStatus(false);
          });
          // lockState = false;
          // lockStorage.write(
          //     'lockState', lockState);
        } else if (lockStatus == "null") {
          print("THE COMMAND WENT NULL");
          Get.back();
          print("HERE");
          Future<void> _showMyDialog() async {
            return showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Try Again Later',
                      style: TextStyle(
                          color: darkBlueColor, fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok',
                          style: TextStyle(
                              color: darkBlueColor,
                              fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      });
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    _timerController = TimerController(this);
    super.initState();
    sendLockApi();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: DrawerWidget(
              mobileNum: '7715813911',
              userName: 'Akshay Krishna',
            ),
          ),
          appBar: AppBar(
              title: const Text(
                "Liveasy GPS Installer",
                style: TextStyle(
                    color: darkBlueColor, fontWeight: FontWeight.w700),
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
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              )),
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Relay Check 1',
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
                      Text("Checking Relay - Cutting off the fuel supply",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "montserrat")),
                      const SizedBox(
                        height: 32,
                      ),
                      Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Text('Status',
                                            style: TextStyle(fontSize: 10)),
                                        getFieldText(1),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                (ignitionStatus != "On")
                                    ? Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Update ke liye ruke',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: darkBlueColor)),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            SizedBox(
                                              height: 36,
                                              child: SimpleTimer(
                                                status: TimerStatus.start,
                                                duration:
                                                    const Duration(seconds: 15),
                                                // controller: _timerController,
                                                onEnd: () {
                                                  sendLockApi();
                                                  if (ignitionStatus != "On") {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            _createRoute());
                                                  }
                                                },
                                                progressIndicatorColor:
                                                    darkBlueColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text('Successfully Turned ON',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: darkBlueColor)),
                                      ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            )),
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RelayCheckTwo(
        taskId: widget.taskId,
        driverName: widget.driverName,
        driverPhoneNo: widget.driverPhoneNo,
        vehicleNo: widget.vehicleNo,
        vehicleOwnerName: widget.vehicleOwnerName,
        vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  Row getNavMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () => {
                  Get.to(StepsView(
                    taskId: widget.taskId,
                    driverName: widget.driverName,
                    driverPhoneNo: widget.driverPhoneNo,
                    vehicleNo: widget.vehicleNo,
                    vehicleOwnerName: widget.vehicleOwnerName,
                    vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
                  ))
                },
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
                      Get.to(RelayCheckTwo(
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
              (ignitionStatus == "On")
                  ? Icons.check_circle
                  : FontAwesomeIcons.exclamationCircle,
              color: (ignitionStatus == "On") ? Colors.green : Colors.red,
              size: 12),
        SizedBox(
          width: 2,
        ),
        if (textType == 2)
          Icon(FontAwesomeIcons.exclamationCircle, color: Colors.red, size: 12),
        // Icon(Icons.check_circle, color: Colors.green, size: 12),
        SizedBox(
          width: 2,
        ),
        if (textType == 1 && ignitionStatus != "On")
          Text(
            "Turn the ignition ON",
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
      ],
    );
  }
}
