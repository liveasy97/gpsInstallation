import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

Future<String> postHardwarePictures(
    {String? picture, String? documentType}) async {
  try {
    final String documentApiUrl =
        FlutterConfig.get("documentApiUrl").toString();
    Map data = {
      "documents": [
        {"data": picture, "documentType": documentType, "verified": true}
      ],
      "entityId": "7979797979"
    };
    String body = json.encode(data);

    final response = await http.post(Uri.parse(documentApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      print("Success");
      Get.back();
      return "Success";
    } else {
      print("Failed");
      return "Error ${response.statusCode} \n Printing Response ${response.body}";
    }
  } catch (e) {
    print("Error is $e");
    Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    return "Error Occurred";
  }
}
