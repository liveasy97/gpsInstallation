import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/screens/stepsView.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationCheck extends StatefulWidget {
  int taskId;
  String vehicleNo;
  String driverName;
  String driverPhoneNo;
  String vehicleOwnerName;
  String vehicleOwnerPhoneNo;
  LocationCheck(
      {required this.vehicleNo,
      required this.driverName,
      required this.driverPhoneNo,
      required this.vehicleOwnerName,
      required this.vehicleOwnerPhoneNo,
      required this.taskId});

  @override
  State<LocationCheck> createState() => _LocationCheckState();
}

class _LocationCheckState extends State<LocationCheck> {
  bool successLoading = false;
  String _vicinity = "Unknown";
  String warningText = "Loding, please wait!";
  String mapsKey = FlutterConfig.get("mapKey");

  Future<void> _getAddress(double lat, double lang) async {
    final prefs = await SharedPreferences.getInstance();
    print("COORDINATES ARE : " + lat.toString() + ' ' + lang.toString());
    print("Doing");
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
    print("locationFromAddress:" +
        placemarks[0].street.toString() +
        ',' +
        placemarks[0].name.toString() +
        ',' +
        placemarks[0].locality.toString() +
        ',' +
        placemarks[0].administrativeArea.toString() +
        ',' +
        placemarks[0].postalCode.toString());

    setState(() {
      _vicinity = placemarks[0].street.toString() +
          ',' +
          placemarks[0].name.toString() +
          ',' +
          placemarks[0].locality.toString() +
          ',' +
          placemarks[0].administrativeArea.toString() +
          ',' +
          placemarks[0].postalCode.toString();
      successLoading = true;

      TaskFetcher.dataForEachTask[widget.taskId].locationStatus = 2;
      prefs.setInt(widget.vehicleNo.toString() + '_4', 2);

      TaskFetcher.dataForEachTask[widget.taskId].relayStatusOne = 1;
      prefs.setInt(widget.vehicleNo.toString() + '_5', 1);

      print(_vicinity);
    });
  }

  @override
  void initState() {
    super.initState();
    _getAddress(MyApp.latitude, MyApp.longitude);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                onPressed: () => {}),
          ),
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Location check',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(
                            height: 12,
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                                      Text('Location check',
                                          style: TextStyle(fontSize: 10)),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      getFieldText(1),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text('Location detected',
                                          style: TextStyle(fontSize: 10)),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      getFieldText(2),
                                      const SizedBox(
                                        height: 12,
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
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  successLoading = false;
                                  warningText = "Refreshing";
                                  _getAddress(MyApp.latitude, MyApp.longitude);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/reload.png',
                                      color: darkBlueColor,
                                      scale: 3,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text('Refresh',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: getNavMenu(),
                      )
                    ],
                  )))),
      onWillPop: () {
        Get.to(StepsView(
          taskId: widget.taskId,
          driverName: widget.driverName,
          driverPhoneNo: widget.driverPhoneNo,
          vehicleNo: widget.vehicleNo,
          vehicleOwnerName: widget.vehicleOwnerName,
          vehicleOwnerPhoneNo: widget.vehicleOwnerPhoneNo,
        ));
        return Future.value(true); // if true allow back else block it
      },
    );
  }

  Row getNavMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => Get.back(),
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
        Text('Step 5 of 7', style: const TextStyle(fontSize: 12)),
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

  Row getFieldText(int textType) {
    double width = MediaQuery.of(context).size.width;

    if (successLoading) {
      String textHere = "Unknown";
      switch (textType) {
        case 1:
          textHere = _vicinity;
          break;
        case 2:
          textHere = "True";
          break;
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Container(
            width: width / 1.5,
            child: Text(
              textHere,
              style: TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.clip,
            ),
          ),
          // Text(
          //   textHere,
          //   maxLines: 2,
          //   overflow: TextOverflow.clip,
          //   textAlign: TextAlign.justify,
          //   style: TextStyle(fontSize: 14),
          // ),
          SizedBox(
            width: 4,
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 12),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Icon(FontAwesomeIcons.exclamationCircle,
            color: darkBlueColor, size: 12),
        SizedBox(
          width: 4,
        ),
        Text(
          warningText,
          style: TextStyle(fontSize: 16, color: darkBlueColor),
        ),
      ],
    );
  }
}
