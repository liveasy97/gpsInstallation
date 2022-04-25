// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/constants/fontSize.dart';
import 'package:gpsinstallation/constants/fontWeights.dart';
import 'package:gpsinstallation/constants/radius.dart';
import 'package:gpsinstallation/constants/spaces.dart';
import 'package:gpsinstallation/data/installDataHolder.dart';
import 'package:gpsinstallation/models/installerTaskDataModel.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:gpsinstallation/widgets/drawerWidget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskFetcher extends StatefulWidget {
  const TaskFetcher({Key? key}) : super(key: key);
  static late List<InstallDataHolder> dataForEachTask = <InstallDataHolder>[];
  @override
  State<TaskFetcher> createState() => _TaskFetcherState();
}

class _TaskFetcherState extends State<TaskFetcher> {
  String installerAPIKey = FlutterConfig.get("installerApi");
  late List<InstallerTaskModel> _installerTaskListModel =
      <InstallerTaskModel>[];
  bool successLoading = false;
  var prefs;
  Future<void> callApi() async {
    EasyLoading.show(status: 'Loading...');
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    var url = Uri.parse(installerAPIKey + "?gpsInstallerId=" + uid);
    var response = await http.get(url);
    var body = response.body;
    try {
      _installerTaskListModel = (json.decode(response.body) as List)
          .map((data) => InstallerTaskModel.fromJson(data))
          .toList();
    } catch (e) {}
    setState(() {
      for (int i = 0; i < _installerTaskListModel.length; i++) {
        TaskFetcher.dataForEachTask.add(InstallDataHolder(
            installerTaskID: _installerTaskListModel[i].installerTaskId));
        print("DATA HERE " +
            TaskFetcher.dataForEachTask[i].installerTaskID.toString());
        successLoading = true;
      }
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    callApi();
  }

  int backCount = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name = "Akshay";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
          return Future.value(true);
        },
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
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text('Aapke tasks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                  child: (successLoading)
                      ? RefreshIndicator(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.vertical,
                              itemCount: (_installerTaskListModel[0] != null)
                                  ? _installerTaskListModel.length
                                  : 0,
                              itemBuilder: (context, index) {
                                InstallerTaskModel here =
                                    _installerTaskListModel[index];
                                print("DISTANCE ABCD " +
                                    here.driverName.toString());
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                    child: GestureDetector(
                                      onTap: (() async {
                                        prefs = await SharedPreferences
                                            .getInstance();
                                        String? currentTask =
                                            prefs.getString("CurrentTask");

                                        if (currentTask ==
                                                here.vehicleNo.toString() ||
                                            currentTask == null) {
                                          Get.to(StepsView(
                                            driverName:
                                                here.driverName.toString(),
                                            driverPhoneNo:
                                                here.driverPhoneNo.toString(),
                                            vehicleNo:
                                                here.vehicleNo.toString(),
                                            vehicleOwnerName: here
                                                .vehicleOwnerName
                                                .toString(),
                                            vehicleOwnerPhoneNo: here
                                                .vehicleOwnerPhoneNo
                                                .toString(),
                                            taskId: index,
                                          ));
                                        } else {
                                          _showMyDialog(
                                              here.vehicleNo.toString(),
                                              here,
                                              index);
                                        }
                                      }),
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 16, 16, 16),
                                          child: Table(
                                            columnWidths: {
                                              0: FlexColumnWidth(4),
                                              1: FlexColumnWidth(1),
                                              2: FlexColumnWidth(4),
                                            },
                                            children: [
                                              getTableRow("Vehicle No. : ",
                                                  here.vehicleNo.toString()),
                                              getTableRow("Driver Name : ",
                                                  here.driverName.toString()),
                                              getTableRow(
                                                  "Driver’s No. : ",
                                                  here.driverPhoneNo
                                                      .toString()),
                                              getTableRow(
                                                  "Owner’s Name : ",
                                                  here.vehicleOwnerName
                                                      .toString()),
                                              getTableRow(
                                                  "Owner’s No. : ",
                                                  here.vehicleOwnerPhoneNo
                                                      .toString()),
                                              TableRow(children: [
                                                Text(
                                                  "",
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                Text(
                                                  "",
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      Text(
                                                        "Install Kren",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                darkBlueColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .arrow_right_sharp,
                                                          color: darkBlueColor,
                                                          size: 24),
                                                    ],
                                                  ),
                                                )
                                              ])
                                            ],
                                          ),
                                        ),
                                        elevation: 4,
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ));
                              }),
                          onRefresh: callApi)
                      : Container(),
                ),
              ],
            )));
  }

  TableRow getTableRow(String row1, String row2) {
    return TableRow(children: [
      Text(
        row1,
        style: TextStyle(fontSize: 15.0),
      ),
      Text(
        ":",
        style: TextStyle(fontSize: 15.0),
      ),
      Text(
        row2,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
      ),
    ]);
  }

  Future<void> _showMyDialog(
      String truckNo, InstallerTaskModel here, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Another task in progress',
              style:
                  TextStyle(color: darkBlueColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Installation of GPS on Truck $truckNo in progress."),
                Text('If you proceed, you\'ll lose progress on that task.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(
                      color: darkBlueColor, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Proceed',
                style: TextStyle(
                    color: darkBlueColor, fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                await prefs.remove('CurrentTask');
                await prefs.remove('_CompletedStep');
                await prefs.remove('longitude');
                await prefs.remove('latitude');
                await prefs.remove('deviceId');
                TaskFetcher.dataForEachTask[index] = InstallDataHolder(
                    installerTaskID:
                        _installerTaskListModel[index].installerTaskId);
                Get.to(StepsView(
                  driverName: here.driverName.toString(),
                  driverPhoneNo: here.driverPhoneNo.toString(),
                  vehicleNo: here.vehicleNo.toString(),
                  vehicleOwnerName: here.vehicleOwnerName.toString(),
                  vehicleOwnerPhoneNo: here.vehicleOwnerPhoneNo.toString(),
                  taskId: index,
                ));
              },
            ),
          ],
        );
      },
    );
  }
}
