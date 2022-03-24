// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/models/hardwareDataModel.dart';
import 'package:gpsinstallation/screens/powerCheckOne.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class imeiCheck extends StatefulWidget {
  const imeiCheck({Key? key}) : super(key: key);

  @override
  State<imeiCheck> createState() => _imeiCheckState();
}

// ignore: camel_case_types
class _imeiCheckState extends State<imeiCheck> {
  String _scanBarcode = MyApp.imei;
  String _phoneNumber = MyApp.phone;
  HardwareDataModel _hardwareDataModel = HardwareDataModel();
  String hardwareAPIKey = FlutterConfig.get("hardwareApi");
  bool successLoading = false;
  String warningText = "Scan or Input valid IMEI";

  String removeExtraChar(String multiline) {
    var singleline = multiline.replaceAll("\n", "");
    return singleline;
  }

  Future<void> callApi(String imeiText) async {
    var url = Uri.parse("$hardwareAPIKey?imei=" + imeiText);
    var response = await http.get(url);
    var body = response.body;
    try {
      _hardwareDataModel = HardwareDataModel.fromJson(jsonDecode(body));
      _phoneNumber = _hardwareDataModel.phoneNo!;
      MyApp.phone = _phoneNumber;
      if (_phoneNumber != "Unknown") successLoading = true;
    } catch (e) {
      print("Couldn't load, Input valid IMEI");
      warningText = "Couldn't load, Input valid IMEI";
      successLoading = false;
      print("IMEEE" + MyApp.imei);
    }
    setState(() {});
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = removeExtraChar(barcodeScanRes);
      MyApp.imei = _scanBarcode;
      callApi(_scanBarcode);
    });
  }

  final fieldText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var validatedIcon = 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('IMEI number daalen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 32,
                    ),
                    Image.asset(
                      'assets/icons/hardware.png',
                      fit: BoxFit.contain,
                      height: height / 5,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Flexible(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: TextFormField(
                        controller: fieldText,
                        onChanged: (text) {
                          _scanBarcode = text;
                          setState(() {});
                        },
                        onFieldSubmitted: (text) {
                          _scanBarcode = text;
                          MyApp.imei = _scanBarcode;
                          callApi(_scanBarcode);
                          setState(() {
                            validatedIcon = 1;
                          });
                        },
                        cursorColor: Colors.green,
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: 'IMEI number likhiye',
                          suffixIcon: Icon(Icons.check_circle),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                      ),
                    )),
                    const Text('Or', style: TextStyle(fontSize: 16)),
                    GestureDetector(
                      onTap: () => {scanBarcodeNormal()},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/scanner.png',
                            scale: 3,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text('IMEI number scan kren',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text('SIM card number',
                                    style: TextStyle(fontSize: 10)),
                                getFieldText(1),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text('Relay installation',
                                    style: TextStyle(fontSize: 10)),
                                getFieldText(2),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text('SIM card status',
                                    style: TextStyle(fontSize: 10)),
                                getFieldText(3),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    successLoading = false;
                                    print("IMEIEE" + MyApp.imei);
                                    callApi(MyApp.imei);
                                    warningText = "Refreshing";
                                    Feedback.forTap(context);
                                    setState(() {});
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/reload.png',
                                        scale: 3,
                                      ),
                                      Text('Refresh',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      elevation: 4,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    getNavMenu(),
                  ],
                ))));
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
        Text('Step 1 of 7', style: const TextStyle(fontSize: 12)),
        ElevatedButton(
            onPressed: () => {
                  if (successLoading) {Get.to(PowerCheckOne())}
                },
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
                        borderRadius: BorderRadius.circular(8.0),
                        side: (successLoading)
                            ? BorderSide(color: darkBlueColor)
                            : BorderSide(color: grey))))),
      ],
    );
  }

  Row getFieldText(int textType) {
    if (successLoading) {
      String textHere = "Unknown";
      switch (textType) {
        case 1:
          textHere = _phoneNumber;
          break;
        case 2:
          textHere = "Supported";
          break;
        case 3:
          textHere = "Active";
          break;
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Text(
            textHere,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            width: 2,
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 12),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Icon(FontAwesomeIcons.exclamationCircle, color: Colors.red, size: 12),
        SizedBox(
          width: 4,
        ),
        Text(
          warningText,
          style: TextStyle(fontSize: 12, color: Colors.red),
        ),
      ],
    );
  }
}
