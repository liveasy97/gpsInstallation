import 'dart:convert';
import 'package:get/get.dart';
import 'package:gpsinstallation/controller/transporterIdController.dart';
import 'package:gpsinstallation/functions/lockUnlockController.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:get_storage/get_storage.dart';

TransporterIdController transporterIdController =
    Get.put(TransporterIdController());
final lockStorage = GetStorage();
String? traccarUser = transporterIdController.mobileNum.value;
String traccarPass = FlutterConfig.get("traccarPass");
String traccarApi = FlutterConfig.get("traccarApi");
String basicAuth =
    'Basic ' + base64Encode(utf8.encode('$traccarUser:$traccarPass'));

LockUnlockController lockUnlockController = Get.find<LockUnlockController>();

//TRACCAR API CALLS------------------------------------------------------------
Future<String> postCommandsApi(
  int? deviceId,
  String? type,
  String? description,
) async {
  try {
    Map data = {"deviceId": deviceId, "type": type, "description": description};
    String body = json.encode(data);

    final response = await http.post(Uri.parse("$traccarApi/commands/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': basicAuth,
        },
        body: body);

    if (response.statusCode == 200 || response.statusCode == 202) {
      print(response.body);
      print(
          "THE CONTROLLER VALUE IS ${lockUnlockController.lockUnlockStatus.value}");
      return "Success";
    } else {
      print(
          "Error ${response.statusCode} \n Printing Response ${response.body}");
      return "Error ${response.statusCode} \n Printing Response ${response.body}";
    }
  } catch (e) {
    print("Error is $e");
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    return "Error Occurred";
  }
}

Future<String> getCommandsResultApi(
  int? deviceId,
  var timeNow,
) async {
  var timeCurrent = DateTime.now()
      .subtract(Duration(hours: 5, minutes: 30))
      .toIso8601String();

  print("Current time $timeNow");
  print("TO time $timeCurrent");
  try {
    http.Response response = await http.get(
      Uri.parse(
          "$traccarApi/reports/events?from=${timeNow}Z&to=${timeCurrent}Z&deviceId=$deviceId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth,
      },
    );
    print(response.statusCode);
    print(response.body);
    var jsonData = await jsonDecode(response.body);
    print("The DATA FROM EVENTS $jsonData");
    var store;
    if (response.statusCode == 200) {
      print(response.body);
      print(
          "THE CONTROLLER VALUE IS ${lockUnlockController.lockUnlockStatus.value}");
      for (var json in jsonData) {
        store = json["attributes"]["result"];
      }
      print("THE STORE IS $store");
      if (store == "Restore fuel supply:Success!") {
        print("Restore fuel success");
        lockStorage.write('lockState', true);
        lockUnlockController.lockUnlockStatus.value = true;
        lockUnlockController.updateLockUnlockStatus(true);
        return "unlock";
      } else if (store == "Cut off the fuel supply: Success!") {
        print("Cutoff supply successful");
        lockStorage.write('lockState', false);
        lockUnlockController.lockUnlockStatus.value = false;
        lockUnlockController.updateLockUnlockStatus(false);
        return "lock";
      } else if (store ==
          "Already in the state of  fuel supply cut off, the command is not running!") {
        lockStorage.write('lockState', false);
        lockUnlockController.lockUnlockStatus.value = false;
        lockUnlockController.updateLockUnlockStatus(false);
        return "lock";
      } else if (store ==
          "Already in the state of fuel supply to resume, the command is not running!") {
        lockStorage.write('lockState', true);
        lockUnlockController.lockUnlockStatus.value = true;
        lockUnlockController.updateLockUnlockStatus(true);
        return "unlock";
      } else {
        return "null";
      }
    } else {
      return "null";
    }
  } catch (e) {
    print("Error is $e");
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    return "Error Occurred";
  }
}
