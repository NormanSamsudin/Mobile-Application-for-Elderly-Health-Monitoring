import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:seniorconnect/screens/elderlyScreen/appointmentElderly.dart';
import 'package:seniorconnect/screens/elderlyScreen/medicationElderly.dart';
import 'package:seniorconnect/screens/elderlyScreen/profileElderly.dart';
import 'package:seniorconnect/screens/elderlyScreen/reportElderly.dart';
import 'package:seniorconnect/widgets/elderlyWidget/carouselWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:url_launcher/url_launcher.dart';

class TabScreenElderly extends StatefulWidget {
  @override
  State<TabScreenElderly> createState() => _TabScreenElderlyState();
}

class _TabScreenElderlyState extends State<TabScreenElderly> {
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  final List<Widget> carouselWid = [
    carouselWidget(
        mainText: 'Drink enough water         ',
        subText: 'Avoid beverage and food contain caffeine',
        color: Colors.red,
        imagePath: 'lib/assets/images/cup.png'),
    carouselWidget(
        mainText: 'Do a regular exercise      ',
        subText: 'regular exercise routine can improve sleep quality',
        color: Colors.green,
        imagePath: 'lib/assets/images/jog.png'),
    carouselWidget(
        mainText: 'Consistent sleep                ',
        subText: 'sleep and wake up with consistent schedule',
        color: Colors.blue,
        imagePath: 'lib/assets/images/sleep.png'),
    carouselWidget(

        mainText: 'Screen Time                     ',
        subText: 'keep screen use to a minimum screen time',
        color: Colors.blue,
        imagePath: 'lib/assets/images/screen_time.png'),
  ];

  bool _isPlaying = false;

  GlobalKey _sliderKey = GlobalKey();

  int _currentIndex = 0;

  int _nextIndex = 0;

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    final notificationSetting = await fcm.requestPermission();
    final token = await fcm.getToken();
    fcm.subscribeToTopic('elderly');
    print('Elderly Token: ${token}');
  }

  void callEmergencyNumber() async {
    const emergencyNumber = 'tel:0182402589';
    if (await canLaunch(emergencyNumber)) {
      await launch(emergencyNumber);
    } else {
      print('Could not launch $emergencyNumber');
    }
  }
   Offset position = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              'Elderly Dashboard',
              style: TextStyle(
                color: Color.fromARGB(255, 76, 8, 88),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Color.fromARGB(255, 76, 8, 88),
              ))
        ],
      ),
      backgroundColor: Color.fromRGBO(59, 169, 156, 1),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Daily Tips',
                    style: GoogleFonts.lexend(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    // Swiped to the left
                    _nextIndex = _currentIndex + 1;
                  } else {
                    // Swiped to the right
                    _nextIndex = _currentIndex - 1;
                  }

                  if (_nextIndex >= 0 && _nextIndex < colors.length) {
                    _sliderKey.currentState!;
                    setState(() {
                      _currentIndex = _nextIndex;
                    });
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    //color: tiffany_blue,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  height: 170,
                  child: CarouselSlider.builder(
                    
                    key: _sliderKey,
                    unlimitedMode: true,
                    slideBuilder: (index) {
                      return carouselWid[index];
                    },
                    slideTransform: CubeTransform(),
                    slideIndicator: CircularSlideIndicator(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    itemCount: carouselWid.length,
                    initialPage: _currentIndex,
                    onSlideChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Main Features',
                    style: GoogleFonts.lexend(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  InkWell(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      //color: Colors.green,
                      height: 250,
                      width: MediaQuery.sizeOf(context).width/2 - 25,
                      child: Stack(
                        children: [
                          Container(
                            //height: double.infinity,
                            width: double.infinity,
                          ),
                          Positioned(
                              top: 20,
                              left: 65,
                              child: Text(
                                'Profile',
                                style: GoogleFonts.lexend(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              )),
                          Positioned(
                              top: 70,
                              left: 40,
                              child: SizedBox(
                                height: 120,
                                child: Image.asset(
                                    'lib/assets/images/profile.png'),
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => profileElderly(),
                      ));
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      height: 250,
                      width: MediaQuery.sizeOf(context).width/2 - 25,
                      child: Stack(
                        children: [
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                          ),
                          Positioned(
                              top: 20,
                              left: 30,
                              child: Text(
                                'Appointment',
                                style: GoogleFonts.lexend(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              )),
                          Positioned(
                              top: 70,
                              left: 40,
                              child: SizedBox(
                                height: 120,
                                child: Image.asset(
                                    'lib/assets/images/appointment.png'),
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => appointmentElderly(),
                      ));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      height: 250,
                      width: MediaQuery.sizeOf(context).width/2 - 25,
                      child: Stack(
                        children: [
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                          ),
                          Positioned(
                              top: 20,
                              left: 40,
                              child: Text(
                                'Medication',
                                style: GoogleFonts.lexend(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              )),
                          Positioned(
                              top: 120,
                              left: 80,
                              child: SizedBox(
                                  //height: 120,
                                  child: Container(
                                height: 51,
                                width: 47,
                                color: Colors.white,
                              ))),
                          Positioned(
                              top: 70,
                              left: 40,
                              child: SizedBox(
                                height: 120,
                                child:
                                    Image.asset('lib/assets/images/meds.png'),
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => medicationElderly(),
                      ));
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      height: 250,
                      width: MediaQuery.sizeOf(context).width/2 - 25,
                      child: Stack(
                        children: [
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                          ),
                          Positioned(
                              top: 20,
                              left: 55,
                              child: Text(
                                'Reports',
                                style: GoogleFonts.lexend(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              )),
                          Positioned(
                              top: 70,
                              left: 40,
                              child: SizedBox(
                                height: 120,
                                child: Image.asset(
                                    'lib/assets/images/seo-report.png'),
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => reportElderly(),
                      ));
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // GestureDetector(
              //   onPanUpdate: (details) {
              //     if (details.delta.dx > 0) {
              //       // If dragging right
              //       callEmergencyNumber();
              //       print('hello');
              //     }
              //   },
              //   child: Container(
              //     padding: EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Slide Right to Call Emergency',
              //         style: TextStyle(color: Colors.white, fontSize: 18),
              //       ),
              //     ),
              //   ),
              // ),

              // Container(
              //   height: 100,
              //   child: Stack(
              //       children: <Widget>[
              //         Container(height: 100,
              //         width: 200,),
              //         Positioned(
              //           left: position.dx,
              //           top: position.dy,
              //           child: Draggable(
              //             feedback: CircleAvatar(radius: 20, backgroundColor: Colors.blue),
              //             childWhenDragging: Container(),
              //             onDragEnd: (dragDetails) {
              //   setState(() {
              //     position = dragDetails.offset;
              //   });
              //   if (position.dx <= 0) { // If dragged to the leftmost side
              //     print("hello");
              //   }
              //             },
              //             child: CircleAvatar(radius: 20, backgroundColor: Colors.red),
              //           ),
              //         ),
              //       ],
              //     ),
              // )


              // Container(
              //   child: Stack(
              //       children: <Widget>[
              //         Container(height: 100, width: 200,),
              //         Positioned(
              //           left: position.dx,
              //           top: position.dy,
              //           child: Draggable(
              //             feedback: CircleAvatar(radius: 20, backgroundColor: Colors.blue),
              //             childWhenDragging: Opacity(
              //   opacity: 0.5,
              //   child: CircleAvatar(radius: 20, backgroundColor: Colors.red),
              //             ),
              //             onDragEnd: (dragDetails) {
              //   setState(() {
              //     position = Offset(100, 100); // Reset position after drag ends
              //   });
              //   if (dragDetails.offset.dx <= 0) { // If dragged to the leftmost side
              //     print("hello");
              //   }
              //             },
              //             onDraggableCanceled: (velocity, offset) {
              //   setState(() {
              //     position = Offset(100, 100); // Reset position on drag cancel
              //   });
              //             },
              //             child: CircleAvatar(radius: 20, backgroundColor: Colors.red),
              //           ),
              //         ),
              //       ],
              //     ),
              // ),
            ],
          ),
        ),
      ]),
    );
  }
}
