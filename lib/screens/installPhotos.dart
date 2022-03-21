// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/screens/imagePickerScreen.dart';

class InstallationPhotos extends StatefulWidget {
  const InstallationPhotos({Key? key}) : super(key: key);

  @override
  State<InstallationPhotos> createState() => _InstallationPhotosState();
}

class _InstallationPhotosState extends State<InstallationPhotos> {
  static List<bool> successUploading = [false, false, false];
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Text('Installation photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(
            height: 16,
          ),
          getCard(0, "GPS ka photo upload \nkare"),
          SizedBox(
            height: 12,
          ),
          getCard(1, "Relay ka photo upload \nkare"),
          SizedBox(
            height: 12,
          ),
          getCard(2, "Truck ka samnse se photo \nupload kare"),
        ]),
      ),
    );
  }

  GestureDetector getCard(int cardId, String textHere) {
    return GestureDetector(
      onTap: (() => {Get.to(ImagePickerScreen())}),
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
    return (successUploading[cardId])
        ? Icon(Icons.check_circle, color: Colors.green)
        : Icon(Icons.keyboard_arrow_right, color: Colors.grey);
  }
}
