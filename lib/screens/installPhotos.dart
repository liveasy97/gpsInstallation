// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/screens/imagePickerScreen.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';
import 'package:gpsinstallation/widgets/drawerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstallationPhotos extends StatefulWidget {
  int taskId;
  String vehicleNo;
  String driverName;
  String driverPhoneNo;
  String vehicleOwnerName;
  String vehicleOwnerPhoneNo;
  InstallationPhotos(
      {required this.vehicleNo,
      required this.driverName,
      required this.driverPhoneNo,
      required this.vehicleOwnerName,
      required this.vehicleOwnerPhoneNo,
      required this.taskId});

  static List<bool> successUploading = [false, false, false];
  @override
  State<InstallationPhotos> createState() => _InstallationPhotosState();
}

class _InstallationPhotosState extends State<InstallationPhotos>
    with WidgetsBindingObserver {
  bool successLoading = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // widget is resumed
        setState(() {});
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }

  @override
  void initState() {
    checkStat();
    super.initState();
  }

  Future<void> checkStat() async {
    final prefs = await SharedPreferences.getInstance();
    if (InstallationPhotos.successUploading[0] &&
        InstallationPhotos.successUploading[1] &&
        InstallationPhotos.successUploading[2]) {
      TaskFetcher.dataForEachTask[widget.taskId].photosStatus = 2;
      successLoading = true;
      TaskFetcher.dataForEachTask[widget.taskId].completeStatus = true;

      await prefs.setInt('_CompletedStep', 8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return WillPopScope(
        onWillPop: () {
          Get.to(StepsView(
            taskId: widget.taskId,
            driverName: widget.driverName,
            driverPhoneNo: widget.driverPhoneNo,
            vehicleNo: widget.vehicleNo,
            vehicleOwnerName: widget.vehicleOwnerName,
            vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
          ));
          return Future.value(false);
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
              )),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Installation photos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  Column(
                    children: [
                      getCard(0, "GPS ka photo upload \nkare"),
                      SizedBox(
                        height: 12,
                      ),
                      getCard(1, "Relay ka photo upload \nkare"),
                      SizedBox(
                        height: 12,
                      ),
                      getCard(2, "Truck ka samnse se photo \nupload kare"),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: getNavMenu(),
                  )
                ]),
          ),
        ));
  }

  Row getNavMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => {},
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
        Text('Step 8 of 8', style: const TextStyle(fontSize: 12)),
        ElevatedButton(
            onPressed: () => {},
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

  GestureDetector getCard(int cardId, String textHere) {
    return GestureDetector(
      onTap: (() => {
            if (InstallationPhotos.successUploading[cardId] == false)
              {
                Get.to(ImagePickerScreen(
                  taskId: widget.taskId,
                  driverName: widget.driverName,
                  driverPhoneNo: widget.driverPhoneNo,
                  vehicleNo: widget.vehicleNo,
                  vehicleOwnerName: widget.vehicleOwnerName,
                  vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
                  cardId: cardId,
                ))
              }
          }),
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(textHere,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: GestureDetector(onTap: () {}, child: getIcon(cardId)))
            ],
          ),
        ),
        elevation: 4,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }

  Icon getIcon(int cardId) {
    return (InstallationPhotos.successUploading[cardId])
        ? Icon(Icons.check_circle, color: Colors.green)
        : Icon(Icons.keyboard_arrow_right, color: Colors.grey);
  }
}
