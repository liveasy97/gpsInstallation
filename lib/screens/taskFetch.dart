import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/models/installerTaskDataModel.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:http/http.dart' as http;

class TaskFetcher extends StatefulWidget {
  const TaskFetcher({Key? key}) : super(key: key);

  @override
  State<TaskFetcher> createState() => _TaskFetcherState();
}

class _TaskFetcherState extends State<TaskFetcher> {
  String installerAPIKey = FlutterConfig.get("installerApi");
  late List<InstallerTaskModel> _installerTaskListModel;
  Future<void> callApi() async {
    var url = Uri.parse("$installerAPIKey");
    var response = await http.get(url);
    var body = response.body;
    //_installerTaskModel = InstallerTaskModel.fromJson(jsonDecode(body));
    _installerTaskListModel = (json.decode(response.body) as List)
        .map((data) => InstallerTaskModel.fromJson(data))
        .toList();
    setState(() {});
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
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.vertical,
                  itemCount: (_installerTaskListModel[0] != null)
                      ? _installerTaskListModel.length
                      : 0,
                  itemBuilder: (context, index) {
                    InstallerTaskModel here = _installerTaskListModel[index];
                    print("DISTANCE ABCD " + here.driverName.toString());
                    return Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                            ))
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Text(
                                        "Vehicle No. : " +
                                            here.vehicleNo.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Driver Name : " +
                                            here.driverName.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Driver’s No. : " +
                                            here.driverPhoneNo.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Owner’s Name : " +
                                            here.vehicleOwnerName.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Owner’s No. : " +
                                            here.vehicleOwnerPhoneNo.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Install kare",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: darkBlueColor),
                                      ),
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
                        ));
                  }),
            ),
          ],
        ));
  }
}
