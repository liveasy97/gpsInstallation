import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/models/traccerDataModel.dart';
import 'package:gpsinstallation/models/truckDataModel.dart';
import 'package:http/http.dart' as http;

class PowerCheckOne extends StatefulWidget {
  const PowerCheckOne({Key? key}) : super(key: key);

  @override
  State<PowerCheckOne> createState() => _PowerCheckOneState();
}

class _PowerCheckOneState extends State<PowerCheckOne> {
  String truckApi = FlutterConfig.get("truckApiUrl");
  String traccarApi = FlutterConfig.get("traccarApi");

  String traccarUser = FlutterConfig.get("traccarUser");
  String traccarPass = FlutterConfig.get("traccarPass");

  late List<TruckDataModel> _truckDataModel;

  late List<TraccarDataModel> _traccarDataModel;
  String deviceId = "Unknown";
  String ignitionStatus = "Unknown";

  Future<void> callApiGetDeviceId() async {
    var url = Uri.parse(truckApi);
    var response = await http.get(url);
    var body = response.body;
    List<dynamic> parsedListJson = jsonDecode(body);
    _truckDataModel = List<TruckDataModel>.from(
        parsedListJson.map((i) => TruckDataModel.fromJson(i)));

    for (var i = 0; i < _truckDataModel.length; i++) {
      if (_truckDataModel[i].imei == MyApp.imei) {
        deviceId = _truckDataModel[i].deviceId.toString();
        print("DEVICE ID IS " + deviceId);
      }
    }
    callApiGetStatus();
    setState(() {});
  }

  Future<void> callApiGetStatus() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));
    var url = Uri.parse(traccarApi + "/positions?deviceId=" + deviceId);

    var response = await http
        .get(url, headers: <String, String>{'authorization': basicAuth});
    var body = response.body;

    List<dynamic> parsedListJson = jsonDecode(body);
    _traccarDataModel = List<TraccarDataModel>.from(
        parsedListJson.map((i) => TraccarDataModel.fromJson(i)));
    //_traccarDataModel = TraccarDataModel.fromJson(jsonDecode(body));
    print("IGNITION STATUS IS" +
        _traccarDataModel[0].attributes!.ignition!.toString());
    if (_traccarDataModel[0].attributes!.ignition!) {
      ignitionStatus = "On";
    } else {
      ignitionStatus = "Off";
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callApiGetDeviceId();
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
                        child: RichText(
                      text: const TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Task: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          TextSpan(text: "Ignition"),
                          TextSpan(
                              text: ' OFF ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "Kren")
                        ],
                      ),
                    )),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text("IMEI : " + MyApp.imei + '\n',
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Ignition status : $ignitionStatus\n',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ))));
  }
}
