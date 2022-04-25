import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/data/installDataHolder.dart';
import 'package:gpsinstallation/screens/imeiCheck.dart';
import 'package:gpsinstallation/screens/installPhotos.dart';
import 'package:gpsinstallation/screens/locationCheck.dart';
import 'package:gpsinstallation/screens/powerCheckOne.dart';
import 'package:gpsinstallation/screens/powerCheckTwo.dart';
import 'package:gpsinstallation/screens/relayCheckOne.dart';
import 'package:gpsinstallation/screens/relayCheckTwo.dart';
import 'package:gpsinstallation/screens/submittedScreen.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';
import 'package:gpsinstallation/widgets/drawerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepsView extends StatefulWidget {
  String vehicleNo;
  String driverName;
  String driverPhoneNo;
  String vehicleOwnerName;
  String vehicleOwnerPhoneNo;
  int taskId;
  StepsView(
      {required this.vehicleNo,
      required this.driverName,
      required this.driverPhoneNo,
      required this.vehicleOwnerName,
      required this.vehicleOwnerPhoneNo,
      required this.taskId});

  @override
  State<StepsView> createState() => _StepsViewState();
}

class _StepsViewState extends State<StepsView> {
  List<String> steps = [
    "Enter IMEI number",
    "Connectivity check",
    "Power check 1",
    "Power check 2",
    "Location check",
    "Relay check 1",
    "Relay check 2",
    "Installation photos"
  ];

  var prefs;

  @override
  void initState() {
    EasyLoading.show(status: 'Loading...');
    initializeSP();
    super.initState();
  }

  Future<void> initializeSP() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("CurrentTask", widget.vehicleNo);

    try {
      int completedStep = prefs.getInt('_CompletedStep');
      int nextStep = completedStep + 1;

      TaskFetcher.dataForEachTask[widget.taskId].imeiStatus =
          (completedStep >= 1)
              ? 2
              : (nextStep == 1)
                  ? 1
                  : 0;

      TaskFetcher.dataForEachTask[widget.taskId].connectivityStatus =
          (completedStep >= 2)
              ? 2
              : (nextStep == 2)
                  ? 1
                  : 0;

      TaskFetcher.dataForEachTask[widget.taskId].powerOneStatus =
          (completedStep >= 3)
              ? 2
              : (nextStep == 3)
                  ? 1
                  : 0;

      TaskFetcher.dataForEachTask[widget.taskId].powerTwoStatus =
          (completedStep >= 4)
              ? 2
              : (nextStep == 4)
                  ? 1
                  : 0;

      TaskFetcher.dataForEachTask[widget.taskId].locationStatus =
          (completedStep >= 5)
              ? 2
              : (nextStep == 5)
                  ? 1
                  : 0;

      TaskFetcher.dataForEachTask[widget.taskId].relayStatusOne =
          (completedStep >= 6)
              ? 2
              : (nextStep == 6)
                  ? 1
                  : 0;

      TaskFetcher.dataForEachTask[widget.taskId].relayStatusTwo =
          (completedStep >= 7)
              ? 2
              : (nextStep == 7)
                  ? 1
                  : 0;

      TaskFetcher.dataForEachTask[widget.taskId].photosStatus =
          (completedStep >= 8)
              ? 2
              : (nextStep == 8)
                  ? 1
                  : 0;

      setState(() {});
    } catch (e) {
      print("ERROR OCCURRED" + e.toString());
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    double width = MediaQuery.of(context).size.width;
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
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                          getTableRow(
                              "Vehicle No. : ", widget.vehicleNo.toString()),
                          getTableRow(
                              "Driver Name : ", widget.driverName.toString()),
                          getTableRow("Driver’s No. : ",
                              widget.driverPhoneNo.toString()),
                          getTableRow("Owner’s Name : ",
                              widget.vehicleOwnerName.toString()),
                          getTableRow("Owner’s No. : ",
                              widget.vehicleOwnerPhoneNo.toString()),
                        ],
                      ),
                    ),
                    elevation: 4,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: Row(
                    children: [
                      Text('Installation steps',
                          style: TextStyle(
                              fontSize: 24,
                              color: darkBlueColor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 8,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        onTap: () => {NavigateToView(i)},
                        child: Card(
                          color: (getStatus(i) == 0)
                              ? Color(0xffF6F6F6)
                              : Colors.white,
                          child: Container(
                            height: 290,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Step ' + (i + 1).toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width / 6,
                                          child: Text(
                                            steps[i],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                    getStatusRow(i)
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
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 100,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: getNavMenu(),
            )
          ],
        ),
      ),
      onWillPop: () {
        Get.to(TaskFetcher());
        return Future.value(true); // if true allow back else block it
      },
    );
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

  Row getStatusRow(int i) {
    int? status = getStatus(i);
    String statusText = "Pending";
    Color statusColor = Colors.grey;
    switch (status) {
      case 1:
        statusText = "Start";
        statusColor = darkBlueColor;
        break;
      case 2:
        statusText = "Done";
        statusColor = Colors.green;
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Text(
          statusText,
          style: TextStyle(
              fontSize: 12, color: statusColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 4,
        ),
        if (status == 1 || status == 2)
          Icon((status == 1) ? Icons.arrow_right : Icons.check_circle,
              color: statusColor, size: 12)
      ],
    );
  }

  void NavigateToView(int index) {
    switch (index) {
      case 0:
        // if (TaskFetcher.dataForEachTask[widget.taskId].imeiStatus == 1) {
        Get.to(imeiCheck(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        //   }
        break;
      case 1:
        //Get.to(imeiCheck(taskId: 0));
        break;
      case 2:
        //   if (TaskFetcher.dataForEachTask[widget.taskId].powerOneStatus == 1) {
        Get.to(PowerCheckOne(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        //  }
        break;
      case 3:
        //  if (TaskFetcher.dataForEachTask[widget.taskId].powerTwoStatus == 1) {
        Get.to(PowerCheckTwo(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        //   }
        break;
      case 4:
        //   if (TaskFetcher.dataForEachTask[widget.taskId].locationStatus == 1) {
        Get.to(LocationCheck(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        //   }
        break;
      case 5:
        //    if (TaskFetcher.dataForEachTask[widget.taskId].relayStatusOne == 1) {
        Get.to(RelayCheckOne(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        //    }
        break;
      case 6:
        //  if (TaskFetcher.dataForEachTask[widget.taskId].relayStatusTwo == 1) {
        Get.to(RelayCheckTwo(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        //   }
        break;
      case 7:
        //   if (TaskFetcher.dataForEachTask[widget.taskId].photosStatus == 1) {
        Get.to(InstallationPhotos(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        //   }
        break;
    }
  }

  int? getStatus(int i) {
    int? result = 0;
    switch (i) {
      case 0:
        result = TaskFetcher.dataForEachTask[widget.taskId].imeiStatus;
        break;
      case 1:
        result = TaskFetcher.dataForEachTask[widget.taskId].connectivityStatus;
        break;
      case 2:
        result = TaskFetcher.dataForEachTask[widget.taskId].powerOneStatus;
        break;
      case 3:
        result = TaskFetcher.dataForEachTask[widget.taskId].powerTwoStatus;
        break;
      case 4:
        result = TaskFetcher.dataForEachTask[widget.taskId].locationStatus;
        break;
      case 5:
        result = TaskFetcher.dataForEachTask[widget.taskId].relayStatusOne;
        break;
      case 6:
        result = TaskFetcher.dataForEachTask[widget.taskId].relayStatusTwo;
        break;
      case 7:
        result = TaskFetcher.dataForEachTask[widget.taskId].photosStatus;
        break;
    }
    return result;
  }

  Row getNavMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => Get.to(TaskFetcher()),
          style: ElevatedButton.styleFrom(
              side: BorderSide(
                width: 1.0,
                color: darkBlueColor,
              ),
              primary: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)))),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Back",
              style: TextStyle(color: darkBlueColor),
            ),
          ),
        ),
        Text('', style: const TextStyle(fontSize: 12)),
        ElevatedButton(
            onPressed: () => {Get.to(SubmittedScreen())},
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Submit",
                style: TextStyle(color: white),
              ),
            ),
            style: ButtonStyle(
                backgroundColor:
                    (TaskFetcher.dataForEachTask[widget.taskId].completeStatus)
                        ? MaterialStateProperty.all<Color>(darkBlueColor)
                        : MaterialStateProperty.all<Color>(grey),
                shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: (TaskFetcher
                                .dataForEachTask[widget.taskId].completeStatus)
                            ? BorderSide(color: darkBlueColor)
                            : BorderSide(color: grey))))),
      ],
    );
  }
}
