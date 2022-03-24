import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/screens/imeiCheck.dart';
import 'package:gpsinstallation/screens/installPhotos.dart';
import 'package:gpsinstallation/screens/powerCheckOne.dart';
import 'package:gpsinstallation/screens/powerCheckTwo.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String imei = "Unknown";
  static String phone = "Unknown";
  static List<bool> successUploading = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          fontFamily: "montserrat", scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
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
        GetPage(name: '/powerCheck2', page: () => const PowerCheckTwo()),
        GetPage(name: '/installPhotos', page: () => const InstallationPhotos()),
        GetPage(name: '/installerTask', page: () => const TaskFetcher()),
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
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/powerCheck2")},
                    child: const Text('Power Check 2',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/installPhotos")},
                    child: const Text('Installation Photos',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/installerTask")},
                    child: const Text('Installer Tasks',
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
