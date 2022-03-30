import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';

class SubmittedScreen extends StatelessWidget {
  const SubmittedScreen({Key? key}) : super(key: key);

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
          padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/submitted.png",
                    height: height / 3,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text('GPS installed successfully',
                      style: TextStyle(
                          fontSize: 18,
                          color: darkBlueColor,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () => {
                            //Update on the API
                            Get.to(TaskFetcher())
                          },
                      child: new Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 16),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Done",
                                style: TextStyle(color: white),
                              ),
                            ],
                          )),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(darkBlueColor),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side:
                                          BorderSide(color: darkBlueColor))))),
                ],
              )
            ],
          ),
        )));
  }
}
