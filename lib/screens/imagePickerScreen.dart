// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io' as Io;

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

enum ImageSourceType { gallery, camera }

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  var type;
  var _image;
  var imagePicker;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    imagePicker = new ImagePicker();
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
            child: Column(children: [
              Text('GPS ka photo upload kare',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              GestureDetector(
                onTap: () async {
                  var source = type == ImageSourceType.camera
                      ? ImageSource.camera
                      : ImageSource.gallery;
                  XFile image = await imagePicker.pickImage(
                      source: source,
                      imageQuality: 50,
                      preferredCameraDevice: CameraDevice.front);
                  final bytes = await Io.File(image.path).readAsBytes();
                  String img64 = base64Encode(bytes);
                  print("IMAGE HERE " + img64);
                  setState(() {
                    _image = File(image.path);
                  });
                },
                child: Card(
                  color: Color(0xffEEEEEE),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            _image == null
                                ? Image.asset(
                                    'assets/icons/upload.png',
                                    fit: BoxFit.contain,
                                    height: height / 5,
                                  )
                                : Image.file(
                                    _image,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.fitHeight,
                                  ),
                            Text('Phone se upload kren',
                                style: TextStyle(fontSize: 12)),
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
              )
            ]),
          ),
        ));
  }
}
