import 'dart:convert';
import 'package:get/get.dart';
import 'package:gpsinstallation/main.dart';
import 'package:gpsinstallation/screens/installPhotos.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

Future<String> postHardwarePictures({
  String? picture,
  String? documentType,
  int CardId = 3,
  int taskId = 0,
  required String vehicleNo,
  required String driverName,
  required String driverPhoneNo,
  required String vehicleOwnerName,
  required String vehicleOwnerPhoneNo,
}) async {
  try {
    final String documentApiUrl =
        FlutterConfig.get("documentApiUrl").toString();
    Map data = {
      "documents": [
        {"data": picture, "documentType": documentType, "verified": true}
      ],
      "entityId": MyApp.imei
    };
    String body = json.encode(data);

    final getResponse =
        await http.get(Uri.parse("$documentApiUrl/" + MyApp.imei.toString()));
    if (getResponse.statusCode == 200 || getResponse.statusCode == 201) {
      print(getResponse.body);
      print("Already posted");

      final response =
          await http.put(Uri.parse("$documentApiUrl/" + MyApp.imei.toString()),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        print("Success PUT");
        Get.to(InstallationPhotos(
          taskId: taskId,
          driverName: driverName,
          driverPhoneNo: driverPhoneNo,
          vehicleNo: vehicleNo,
          vehicleOwnerName: vehicleOwnerName,
          vehicleOwnerPhoneNo: vehicleOwnerPhoneNo,
        ));
        InstallationPhotos.successUploading[CardId] = true;
        return "Success";
      } else {
        print("Failed");
        return "Error ${response.statusCode} \n Printing Response ${response.body}";
      }
    } else {
      final response = await http.post(Uri.parse(documentApiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        print("Success");
        InstallationPhotos.successUploading[CardId] = true;
        Get.to(InstallationPhotos(
          taskId: taskId,
          driverName: driverName,
          driverPhoneNo: driverPhoneNo,
          vehicleNo: vehicleNo,
          vehicleOwnerName: vehicleOwnerName,
          vehicleOwnerPhoneNo: vehicleOwnerPhoneNo,
        ));
        return "Success";
      } else {
        print("Failed");
        return "Error ${response.statusCode} \n Printing Response ${response.body}";
      }
    }
  } catch (e) {
    print("Error is $e");
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    return "Error Occurred";
  }
}
