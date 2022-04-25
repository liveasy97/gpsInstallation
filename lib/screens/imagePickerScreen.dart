// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/functions/postHardwarePictures.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:gpsinstallation/widgets/drawerWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io' as Io;

class ImagePickerScreen extends StatefulWidget {
  int cardId;
  int taskId;
  String vehicleNo;
  String driverName;
  String driverPhoneNo;
  String vehicleOwnerName;
  String vehicleOwnerPhoneNo;
  ImagePickerScreen({
    required this.cardId,
    required this.taskId,
    required this.vehicleNo,
    required this.driverName,
    required this.driverPhoneNo,
    required this.vehicleOwnerName,
    required this.vehicleOwnerPhoneNo,
  });
  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

enum ImageSourceType { gallery, camera }

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  var type;
  var _image1;
  var _image2;
  var imagePicker;
  String img64 = "Unknown";
  bool picked = false;
  String titleText = "Upload Photo";
  String documentType = "Unknown";
  bool photoSelected = false;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    photoSelected = false;
    imagePicker = new ImagePicker();
    switch (widget.cardId) {
      case 0:
        titleText = "GPS ka photo upload kare";
        documentType = "GPSPhoto";
        break;
      case 1:
        titleText = "Relay ka photo upload kare";
        documentType = "RelayPhoto";

        break;
      case 2:
        titleText = "Truck ka saamne se photo\nupload kare";
        documentType = "TruckPhoto";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            )),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(titleText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  (photoSelected)
                      ? Card(
                          color: Color(0xffEEEEEE),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(16),
                                      child: Image.file(
                                        (_image1 != null) ? _image1 : _image2,
                                        width: 250.0,
                                        height: 250,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          photoSelected = false;
                                          _image1 = null;
                                          _image2 = null;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: darkBlueColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Icon(Icons.arrow_back_outlined,
                                              color: white, size: 18),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Select another photo",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
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
                        )
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var source = type = ImageSource.gallery;
                                XFile image = await imagePicker.pickImage(
                                    source: source,
                                    imageQuality: 50,
                                    preferredCameraDevice: CameraDevice.front);
                                final bytes =
                                    await Io.File(image.path).readAsBytes();
                                img64 = base64Encode(bytes);
                                picked = true;
                                setState(() {
                                  _image1 = File(image.path);
                                  photoSelected = true;
                                  _image2 = null;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                child: Card(
                                  color: Color(0xffEEEEEE),
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(16),
                                              child: _image1 == null
                                                  ? Image.asset(
                                                      'assets/icons/upload.png',
                                                      fit: BoxFit.contain,
                                                      height: height / 11,
                                                    )
                                                  : Image.file(
                                                      _image1,
                                                      width: 150.0,
                                                      height: 150.0,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text('Phone se upload karen',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  elevation: 4,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text('Or',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () async {
                                var source = type = ImageSource.camera;
                                XFile image = await imagePicker.pickImage(
                                    source: source,
                                    imageQuality: 50,
                                    preferredCameraDevice: CameraDevice.rear);
                                final bytes =
                                    await Io.File(image.path).readAsBytes();
                                img64 = base64Encode(bytes);
                                picked = true;
                                setState(() {
                                  _image2 = File(image.path);
                                  photoSelected = true;
                                  _image1 = null;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                child: Card(
                                  color: Color(0xffEEEEEE),
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(16),
                                              child: _image2 == null
                                                  ? Image.asset(
                                                      'assets/icons/click.png',
                                                      fit: BoxFit.contain,
                                                      height: height / 11,
                                                    )
                                                  : Image.file(
                                                      _image2,
                                                      width: 150.0,
                                                      height: 150.0,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text('Camera se photo kheechen',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  elevation: 4,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ),
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
        Text('', style: const TextStyle(fontSize: 12)),
        ElevatedButton(
            onPressed: () => {
                  if (picked)
                    {
                      postHardwarePictures(
                        picture: img64,
                        documentType: documentType,
                        CardId: widget.cardId,
                        taskId: widget.taskId,
                        driverName: widget.driverName,
                        driverPhoneNo: widget.driverPhoneNo,
                        vehicleNo: widget.vehicleNo,
                        vehicleOwnerName: widget.vehicleOwnerName,
                        vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
                      )
                    },
                  setState(() {})
                },
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Done",
                style: TextStyle(color: white),
              ),
            ),
            style: ButtonStyle(
                backgroundColor: (picked)
                    ? MaterialStateProperty.all<Color>(darkBlueColor)
                    : MaterialStateProperty.all<Color>(grey),
                shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: (picked)
                            ? BorderSide(color: darkBlueColor)
                            : BorderSide(color: grey))))),
      ],
    );
  }
}
