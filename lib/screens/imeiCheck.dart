import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/models/hardwareDataModel.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class imeiCheck extends StatefulWidget {
  const imeiCheck({Key? key}) : super(key: key);

  @override
  State<imeiCheck> createState() => _imeiCheckState();
}

// ignore: camel_case_types
class _imeiCheckState extends State<imeiCheck> {
  String _scanBarcode = 'Unknown';
  String _phoneNumber = "Unknown";
  HardwareDataModel _hardwareDataModel = new HardwareDataModel();
  String hardwareAPIKey = FlutterConfig.get("hardwareApi");

  Future<void> callApi(String imeiText) async {
    var url = Uri.parse("$hardwareAPIKey/$imeiText");

    var response = await http.get(url);
    var body = response.body;

    _hardwareDataModel = HardwareDataModel.fromJson(jsonDecode(body));
    _phoneNumber = _hardwareDataModel.phoneNo!;
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
      _scanBarcode = barcodeScanRes;
      MyApp.imei = _scanBarcode;
      callApi(_scanBarcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Liveasy GPS Installer",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormField(
                        onChanged: (text) {
                          _scanBarcode = text;
                          setState(() {});
                        },
                        onFieldSubmitted: (text) {
                          _scanBarcode = text;
                          MyApp.imei = _scanBarcode;
                          callApi(_scanBarcode);
                        },
                        cursorColor: Colors.green,
                        maxLength: 20,
                        decoration: const InputDecoration(
                            labelText: 'IMEI number likhiye',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            suffixIcon: Icon(
                              Icons.check_circle,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                      ),
                    ),
                    const Text('Or', style: TextStyle(fontSize: 16)),
                    GestureDetector(
                      onTap: () => {scanBarcodeNormal()},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/scanner.png',
                            scale: 2.5,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text('IMEI number scan kren',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text('Scan result : $_scanBarcode\n',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Phone Number : $_phoneNumber\n',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ))));
  }
}
