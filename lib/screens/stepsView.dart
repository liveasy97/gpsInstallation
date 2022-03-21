import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gpsinstallation/constants/color.dart';

class StepsView extends StatefulWidget {
  String vehicleNo;
  String driverName;
  String driverPhoneNo;
  String vehicleOwnerName;
  String vehicleOwnerPhoneNo;
  StepsView({
    required this.vehicleNo,
    required this.driverName,
    required this.driverPhoneNo,
    required this.vehicleOwnerName,
    required this.vehicleOwnerPhoneNo,
  });

  @override
  State<StepsView> createState() => _StepsViewState();
}

class _StepsViewState extends State<StepsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Liveasy GPS Installer",
          style: TextStyle(color: darkBlueColor, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Color(0xFFF0F0F0),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Image.asset(
              "assets/icons/drawerIcon.png",
              width: 24.0,
              height: 24.0,
            ),
            // onPressed: () => Scaffold.of(context).openDrawer(),
            onPressed: () => {}),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          "Vehicle details",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Vehicle No. : " + widget.vehicleNo.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Driver Name : " + widget.driverName.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Driver’s No. : " + widget.driverPhoneNo.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Owner’s Name : " +
                              widget.vehicleOwnerName.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Owner’s No. : " +
                              widget.vehicleOwnerPhoneNo.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              elevation: 4,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text('Installation steps',
              style: TextStyle(fontSize: 24, color: darkBlueColor)),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Card getCard() {
    return Card();
  }
}
