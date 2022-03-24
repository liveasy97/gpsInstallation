// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/functions/postHardwarePictures.dart';
import 'package:gpsinstallation/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io' as Io;

class ImagePickerScreen extends StatefulWidget {
  int cardId;
  ImagePickerScreen({
    required this.cardId,
  });
  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

enum ImageSourceType { gallery, camera }

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  var type;
  var _image;
  var imagePicker;
  String img64 = "Unknown";
  bool picked = false;
  String titleText = "Upload Photo";
  String documentType = "Unknown";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
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
    double height = MediaQuery.of(context).size.height;
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
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var source = type = ImageSource.gallery;
                          XFile image = await imagePicker.pickImage(
                              source: source,
                              imageQuality: 50,
                              preferredCameraDevice: CameraDevice.front);
                          final bytes = await Io.File(image.path).readAsBytes();
                          img64 = base64Encode(bytes);
                          picked = true;
                          setState(() {
                            _image = File(image.path);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: Card(
                            color: Color(0xffEEEEEE),
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        child: _image == null
                                            ? Image.asset(
                                                'assets/icons/upload.png',
                                                fit: BoxFit.contain,
                                                height: height / 11,
                                              )
                                            : Image.file(
                                                _image,
                                                width: 150.0,
                                                height: 150.0,
                                                fit: BoxFit.fitHeight,
                                              ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Phone se upload\nkren',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500)),
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
                          final bytes = await Io.File(image.path).readAsBytes();
                          img64 = base64Encode(bytes);
                          picked = true;
                          setState(() {
                            _image = File(image.path);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(Icons.camera_enhance,
                                color: Colors.grey, size: 32),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text('Camera se photo kheechen',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  getNavMenu()
                ]),
          ),
        ));
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
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: darkBlueColor))))),
        ElevatedButton(
            onPressed: () => {
                  if (picked)
                    {
                      postHardwarePictures(
                          picture: img64,
                          documentType: documentType,
                          CardId: widget.cardId)
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
                        borderRadius: BorderRadius.circular(8.0),
                        side: (picked)
                            ? BorderSide(color: darkBlueColor)
                            : BorderSide(color: grey))))),
      ],
    );
  }
}
