// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/data/installDataHolder.dart';
import 'package:gpsinstallation/models/installerTaskDataModel.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:http/http.dart' as http;

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

  Future<void> callApi() async {
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
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Liveasy GPS Installer",
            style: TextStyle(color: darkBlueColor, fontWeight: FontWeight.w700),
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
                  ? ListView.builder(
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
                        print("DISTANCE ABCD " + here.driverName.toString());
                        return Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: GestureDetector(
                              onTap: () => {
                                Get.to(StepsView(
                                  driverName: here.driverName.toString(),
                                  driverPhoneNo: here.driverPhoneNo.toString(),
                                  vehicleNo: here.vehicleNo.toString(),
                                  vehicleOwnerName:
                                      here.vehicleOwnerName.toString(),
                                  vehicleOwnerPhoneNo:
                                      here.vehicleOwnerPhoneNo.toString(),
                                  taskId: index,
                                ))
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                      getTableRow("Driver’s No. : ",
                                          here.driverPhoneNo.toString()),
                                      getTableRow("Owner’s Name : ",
                                          here.vehicleOwnerName.toString()),
                                      getTableRow("Owner’s No. : ",
                                          here.vehicleOwnerPhoneNo.toString()),
                                      TableRow(children: [
                                        Text(
                                          "",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text(
                                                "Install Kren",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: darkBlueColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Icon(Icons.arrow_right_sharp,
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
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                            ));
                      })
                  : Container(),
            ),
          ],
        ));
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
}
