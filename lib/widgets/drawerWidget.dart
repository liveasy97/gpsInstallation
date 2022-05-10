import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpsinstallation/constants/color.dart';
import 'package:gpsinstallation/constants/fontSize.dart';
import 'package:gpsinstallation/constants/fontWeights.dart';
import 'package:gpsinstallation/constants/radius.dart';
import 'package:gpsinstallation/constants/spaces.dart';
import 'package:gpsinstallation/controller/navigationIndexController.dart';
import 'package:gpsinstallation/providerclass/drawerProviderClassData.dart';
import 'package:gpsinstallation/screens/loginScreen.dart';
import 'package:gpsinstallation/screens/taskFetch.dart';
import 'package:gpsinstallation/screens/taskFetchComplete.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class DrawerWidget extends StatelessWidget {
  final String mobileNum;
  final String userName;
  final String? imageUrl;

  DrawerWidget(
      {required this.mobileNum, required this.userName, this.imageUrl});

  final padding = EdgeInsets.only(left: space_1, right: space_7);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String name;
    name = userName.length > 17 ? userName.substring(0, 15) + "..." : userName;
    NavigationIndexController navigationIndexController =
        Get.put(NavigationIndexController());
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius_6),
          bottomRight: Radius.circular(radius_6)),
      child: Container(
        width: width / 1.4,
        child: Drawer(
          child: Material(
              color: fadeGrey,
              child: Container(
                child: ListView(
                  children: [
                    SizedBox(
                      height: space_9,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: space_4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: radius_7,
                            backgroundColor: white,
                            child: Container(
                              height: space_7,
                              width: space_7,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/icons/drawerProfile.png'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: space_2,
                          ),
                          name != ""
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      alignment: Alignment.topLeft,
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: mediumBoldWeight,
                                          fontSize: size_7,
                                          fontFamily: 'montserrat',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: space_2),
                                    Text(mobileNum),
                                  ],
                                )
                              : Text(mobileNum),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: space_8,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        title: Text("My Profile",
                            // AppLocalizations.of(context)!.logout,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: size_10,
                                fontFamily: 'montserrat',
                                fontWeight: normalWeight)),
                        leading: Container(
                          margin: EdgeInsets.only(left: space_4),
                          child: ImageIcon(
                              AssetImage('assets/icons/drawerProfile.png'),
                              color: darkBlueColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(TaskFetcher());
                      },
                      child: ListTile(
                        title: Text("Aapke Tasks",
                            // AppLocalizations.of(context)!.logout,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: size_10,
                                fontFamily: 'montserrat',
                                fontWeight: normalWeight)),
                        leading: Container(
                          margin: EdgeInsets.only(left: space_4),
                          child: ImageIcon(
                              AssetImage('assets/icons/drawerTasks.png'),
                              color: darkBlueColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(TaskFetcherComplete());
                      },
                      child: ListTile(
                        title: Text("Completed Tasks",
                            // AppLocalizations.of(context)!.logout,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: size_10,
                                fontFamily: 'montserrat',
                                fontWeight: normalWeight)),
                        leading: Container(
                          margin: EdgeInsets.only(left: space_4),
                          child: ImageIcon(
                              AssetImage(
                                  'assets/icons/drawerCompletedTasks.png'),
                              color: darkBlueColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: space_2,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: space_4),
                      child: Divider(
                        color: black,
                      ),
                    ),
                    SizedBox(
                      height: space_3,
                    ),
                    // ListTile(
                    //   title: Container(
                    //     margin: EdgeInsets.only(left: space_4),
                    //     child: Text(AppLocalizations.of(context)!.about_us,
                    //         style: TextStyle(
                    //             color: darkBlueColor,
                    //             fontSize: size_8,
                    //             fontFamily: 'montserrat',
                    //             fontWeight: regularWeight)),
                    //   ),
                    // )
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        title: Text("Help and Support",
                            // AppLocalizations.of(context)!.logout,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: size_10,
                                fontFamily: 'montserrat',
                                fontWeight: normalWeight)),
                        leading: Container(
                          margin: EdgeInsets.only(left: space_4),
                          child: ImageIcon(
                              AssetImage('assets/icons/drawerHelp.png'),
                              color: darkBlueColor),
                        ),
                      ),
                    ),

                    // ListTile(
                    //   title: Container(
                    //     alignment: Alignment.topLeft,
                    //     padding: EdgeInsets.only(right: 0),
                    //     margin: EdgeInsets.only(left: space_3),
                    //     child: TextButton(
                    //         // AppLocalizations.of(context)!.contact_us,
                    //         onPressed: () {
                    //           String url = 'tel:8290748131';
                    //           UrlLauncher.launch(url);
                    //         },
                    //       style: ButtonStyle(
                    //         fixedSize: MaterialStateProperty.resolveWith((states) { Size.fromWidth(300);Size.fromHeight(600);}),
                    //         maximumSize: MaterialStateProperty.resolveWith((states) { Size.fromWidth(300);Size.fromHeight(600);}),
                    //         overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                    //         ),
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(right: 120.0),
                    //           child: Text('contact_us'.tr, style: TextStyle(
                    //               color: darkBlueColor,
                    //               fontSize: size_8,
                    //               fontFamily: 'montserrat',
                    //               fontWeight: regularWeight),textAlign: TextAlign.left,),
                    //         ),),
                    //   ),
                    // ),
                    SizedBox(
                      height: space_3,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: space_4),
                      child: Divider(
                        color: black,
                      ),
                    ),
                    SizedBox(
                      height: space_5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        EasyLoading.show(status: 'Signing Out...');
                        Future.delayed(const Duration(milliseconds: 500), () {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          auth.signOut();
                          EasyLoading.dismiss();
                          Get.to(Login());
                        });
                      },
                      child: ListTile(
                        title: Text('Logout'.tr,
                            // AppLocalizations.of(context)!.logout,
                            style: TextStyle(
                                color: red,
                                fontSize: size_10,
                                fontFamily: 'montserrat',
                                fontWeight: normalWeight)),
                        leading: Container(
                            margin: EdgeInsets.only(left: space_4),
                            child: Icon(
                              Icons.logout,
                              color: red,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: space_4,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget drawerMenuItem({
    required BuildContext context,
    required NavigationItem item,
    required String text,
    required String image,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius_2),
          bottomRight: Radius.circular(radius_2)),
      child: ListTile(
        selectedTileColor: lightGrey,
        leading: Container(
          margin: EdgeInsets.only(left: space_4),
          child: Image(
            image: AssetImage(image),
            width: space_3,
            height: space_4,
          ),
        ),
        title: Text(text,
            style: TextStyle(
                color: darkBlueColor,
                fontSize: size_8,
                fontFamily: 'montserrat',
                fontWeight: boldWeight)),
      ),
    );
  }
}
