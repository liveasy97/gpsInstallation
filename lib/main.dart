import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/screens/imeiCheck.dart';
import 'package:gpsinstallation/screens/installPhotos.dart';
import 'package:gpsinstallation/screens/locationCheck.dart';
import 'package:gpsinstallation/screens/loginScreen.dart';
import 'package:gpsinstallation/screens/onboarding.dart';
import 'package:gpsinstallation/screens/powerCheckOne.dart';
import 'package:gpsinstallation/screens/powerCheckTwo.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String imei = "Unknown";
  static String phone = "Unknown";
  static double latitude = 0;
  static double longitude = 0;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          fontFamily: "montserrat", scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? TaskFetcher()
          : Onboarding(),
      getPages: [
        GetPage(
            name: '/',
            page: () => const MyHomePage(
                  title: "Index",
                )),
        GetPage(
            name: '/imeiCheck',
            page: () => imeiCheck(
                  taskId: 0,
                  driverName: '',
                  driverPhoneNo: '',
                  vehicleNo: '',
                  vehicleOwnerName: '',
                  vehicleOwnerPhoneNo: '',
                )),
        GetPage(
            name: '/powerCheck1',
            page: () => PowerCheckOne(
                  taskId: 0,
                  driverName: '',
                  driverPhoneNo: '',
                  vehicleNo: '',
                  vehicleOwnerName: '',
                  vehicleOwnerPhoneNo: '',
                )),
        GetPage(
            name: '/powerCheck2',
            page: () => PowerCheckTwo(
                  taskId: 0,
                  driverName: '',
                  driverPhoneNo: '',
                  vehicleNo: '',
                  vehicleOwnerName: '',
                  vehicleOwnerPhoneNo: '',
                )),
        GetPage(
            name: '/installPhotos',
            page: () => InstallationPhotos(
                  taskId: 0,
                  driverName: '',
                  driverPhoneNo: '',
                  vehicleNo: '',
                  vehicleOwnerName: '',
                  vehicleOwnerPhoneNo: '',
                )),
        GetPage(name: '/installerTask', page: () => const TaskFetcher()),
        GetPage(name: '/onboarding', page: () => const Onboarding()),
        GetPage(name: '/loginscreen', page: () => Login()),
        GetPage(
            name: '/locationCheck',
            page: () => LocationCheck(
                  taskId: 0,
                  driverName: '',
                  driverPhoneNo: '',
                  vehicleNo: '',
                  vehicleOwnerName: '',
                  vehicleOwnerPhoneNo: '',
                )),
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
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/onboarding")},
                    child: const Text('Onboarding',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/loginscreen")},
                    child: const Text('Login',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed("/locationCheck")},
                    child: const Text('Check Location',
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
