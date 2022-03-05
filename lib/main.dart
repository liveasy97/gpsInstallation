import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/screens/imeiCheck.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(
        title: "Index",
      ),
      getPages: [
        GetPage(
            name: '/',
            page: () => const MyHomePage(
                  title: "Index",
                )),
        GetPage(name: '/imeiCheck', page: () => const imeiCheck()),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/imeiCheck")},
                    child: const Text('Check Imei',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              )
            ],
          ),
        ],
      )),
    );
  }
}
