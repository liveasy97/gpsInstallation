import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/screens/loginScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController controller;
  bool _backButtonVis = false;
  bool _nextButtonToLogin = false;
  final images = [
    "assets/images/one.png",
    "assets/images/two.png",
    "assets/images/three.png",
    "assets/images/four.png",
  ];
  final instructions = [
    "Liveasy GPS installer\nmai aapka swagat hai !",
    "GPS machine aasani se\ninstall karo!",
    "Ulje ho?\nHume call karo!",
    "Apna truck aasani se\ntrack karo!",
  ];

  @override
  void initState() {
    controller = PageController(viewportFraction: 0.8, keepPage: true)
      ..addListener(() {
        if (controller.offset >= controller.position.maxScrollExtent - 1 &&
            !controller.position.outOfRange) {
          setState(() {
            _nextButtonToLogin = true;
          });
        } else {
          _nextButtonToLogin = false;
        }
        setState(() {
          if (controller.offset == 0) {
            _backButtonVis = false; // show the back-to-top button
          } else {
            _backButtonVis = true; // hide the back-to-top button
          }
        });
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        4,
        (index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Container(
                child: Center(
                    child: Column(
                  children: [
                    Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                    SizedBox(
                      height: 64,
                    ),
                    Text(instructions[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
              ),
            ));
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                      height: 50,
                    ),
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 16),
                            SizedBox(
                              height: 320,
                              child: PageView.builder(
                                itemCount: 4,
                                controller: controller,
                                // itemCount: pages.length,
                                itemBuilder: (_, index) {
                                  return pages[index % pages.length];
                                },
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            Container(
                              child: SmoothPageIndicator(
                                controller: controller,
                                count: pages.length,
                                effect: SwapEffect(
                                  dotHeight: 16,
                                  dotWidth: 16,
                                  type: SwapType.normal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32.0),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: getNavMenu(),
                    )
                  ],
                ))));
  }

  Row getNavMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Visibility(
          child: ElevatedButton(
              onPressed: () => {
                    controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate)
                  },
              child: new Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Back",
                  style: TextStyle(color: darkBlueColor),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(color: darkBlueColor))))),
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _backButtonVis,
        ),
        Text('', style: const TextStyle(fontSize: 12)),
        ElevatedButton(
            onPressed: () => {
                  (!_nextButtonToLogin)
                      ? controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.decelerate)
                      : Get.to(Login())
                },
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Next",
                style: TextStyle(color: white),
              ),
            ),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(darkBlueColor),
                shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: darkBlueColor))))),
      ],
    );
  }
}
