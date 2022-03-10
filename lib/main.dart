import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/screens/imeiCheck.dart';
import 'package:gpsinstallation/screens/powerCheckOne.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String imei = "Unknown";
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
        GetPage(name: '/powerCheck1', page: () => const PowerCheckOne()),
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
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/imeiCheck")},
                    child: const Text('Check Imei',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/powerCheck1")},
                    child: const Text('Power Check 1',
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
