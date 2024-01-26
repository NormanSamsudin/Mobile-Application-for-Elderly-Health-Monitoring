import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/widgets/reportWidget/appointmentReport.dart';
import 'package:seniorconnect/widgets/caregiverWidget/videoStreaming.dart';
import 'package:seniorconnect/widgets/reportWidget/googleFit/bloodGlucoseReport.dart';
import 'package:seniorconnect/widgets/reportWidget/heartRateFullReport.dart';
import 'package:seniorconnect/widgets/reportWidget/medicationReport.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

class dataDashboard extends StatefulWidget {
  dataDashboard(
      {super.key,
      required this.active_energy_burned,
      required this.blood_glucose,
      required this.body_temperature,
      required this.heart_rate});

  final double active_energy_burned;
  final double blood_glucose;
  final double body_temperature;
  final double heart_rate;

  @override
  State<dataDashboard> createState() => _dataDashboardState();
}

class _dataDashboardState extends State<dataDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.height;

    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(59, 169, 156, 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Video Stream Monitoring',
                style: GoogleFonts.lexend(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              VideoStream(),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Realtime Health Data',
                style: GoogleFonts.lexend(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),

              const SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                  width: MediaQuery.sizeOf(context).width / 2 - 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10.0,
                            color: const Color.fromARGB(20, 0, 0, 0))
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        Positioned(
                            top: 10,
                            left: 12,
                            child: Text(
                              'Body Temperature',
                              style: GoogleFonts.lexend(
                                fontSize: 18,
                              ),
                            )),
                        Positioned(
                          top: 50,
                          left: 12,
                          child: Container(
                              height: 80,
                              width: 80,
                              child: Lottie.asset(
                                  'lib/assets/lottie/temperature.json')),
                        ),
                        Positioned(
                            top: 65,
                            right: 40,
                            child: Text(
                              // '${double.parse(widget.body_temperature).toStringAsFixed(1)}'
                              '${widget.body_temperature.toStringAsFixed(1)}',
                              style: GoogleFonts.lexend(
                                  fontSize: 35,
                                  color: Color.fromARGB(158, 0, 0, 0)),
                            )),
                        Positioned(
                            top: 60,
                            right: 20,
                            child: Text(
                              '°C',
                              style: GoogleFonts.lexend(
                                  fontSize: 15,
                                  color: Color.fromARGB(158, 0, 0, 0)),
                            )),
                        if (widget.body_temperature > 36.1 &&
                            widget.body_temperature < 37.2)
                          Positioned(
                            top: 100,
                            right: 20,
                            child: Text(
                              'Normal',
                              style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  color: const Color.fromARGB(158, 0, 0, 0)),
                            ),
                          ),
                        if (widget.body_temperature <= 36.1)
                          Positioned(
                            top: 100,
                            right: 20,
                            child: Text(
                              'Low',
                              style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  color: const Color.fromARGB(158, 0, 0, 0)),
                            ),
                          ),
                        if (widget.body_temperature >= 37.2)
                          Positioned(
                            top: 100,
                            right: 20,
                            child: Text(
                              'High',
                              style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  color: const Color.fromARGB(158, 0, 0, 0)),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // bloodGlucoseReport([], 'caregiver', widget.blood_glucose)
                  Container(
                      height: 150,
                      width: MediaQuery.sizeOf(context).width / 2 - 20,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.0,
                              color: const Color.fromARGB(20, 0, 0, 0))
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                          ),

                          Positioned(
                              top: 10,
                              left: 12,
                              child: Text(
                                'Blood Glucose',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                ),
                              )),

                          Positioned(
                            top: 50,
                            left: 5,
                            child: Container(
                                height: 80,
                                width: 80,
                                child: Lottie.asset(
                                    'lib/assets/lottie/blood.json')),
                          ),

                          Positioned(
                              top: 65,
                              right: 80,
                              child: Text(
                                '${(widget.blood_glucose.toStringAsFixed(1))}',
                                style: GoogleFonts.lexend(
                                    fontSize: 35,
                                    color: Color.fromARGB(158, 0, 0, 0)),
                              )),

                          Positioned(
                              top: 60,
                              right: 20,
                              child: Text(
                                'mmol/L',
                                style: GoogleFonts.lexend(
                                    fontSize: 15,
                                    color: Color.fromARGB(158, 0, 0, 0)),
                              )),

                          //normal range (3.9 - 5.6)
                          if (widget.blood_glucose > 3.9 &&
                              widget.blood_glucose < 5.6)
                            Positioned(
                              top: 100,
                              right: 20,
                              child: Text(
                                'Normal',
                                style: GoogleFonts.lexend(
                                    fontSize: 18,
                                    color: const Color.fromARGB(158, 0, 0, 0)),
                              ),
                            ),

                          if (widget.blood_glucose <= 3.9)
                            Positioned(
                              top: 100,
                              right: 20,
                              child: Text(
                                'Low',
                                style: GoogleFonts.lexend(
                                    fontSize: 18,
                                    color: const Color.fromARGB(158, 0, 0, 0)),
                              ),
                            ),

                          if (widget.blood_glucose >= 5.6)
                            Positioned(
                              top: 100,
                              right: 20,
                              child: Text(
                                'High',
                                style: GoogleFonts.lexend(
                                    fontSize: 18,
                                    color: const Color.fromARGB(158, 0, 0, 0)),
                              ),
                            ),
                        ],
                      )),
                ],
              ),

              // energy burned and heart rate
              const SizedBox(
                height: 15,
              ),

              Container(
                height: 130,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10.0,
                        color: const Color.fromARGB(30, 0, 0, 0))
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Positioned(
                        top: 10,
                        left: 12,
                        child: Text(
                          'Heart Rate',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                          ),
                        )),
                    Positioned(
                      top: 30,
                      left: 12,
                      child: Container(
                          height: 80,
                          width: 80,
                          child: Lottie.asset(
                              'lib/assets/lottie/heart_rate.json')),
                    ),
                    Positioned(
                        top: 45,
                        left: 100,
                        child: Text(
                          '${widget.heart_rate.toStringAsFixed(0)}',
                          style: GoogleFonts.lexend(
                            fontSize: 35,
                          ),
                        )),
                    Positioned(
                        top: 65,
                        left: 160,
                        child: Text(
                          'BPM',
                          style: GoogleFonts.lexend(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        )),
                    Positioned(
                        top: 15,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => heartRateFullReport(),
                            ));
                          },
                          child: Text(
                            'Full Report >',
                            style: GoogleFonts.lexend(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        )),
                    Positioned(
                        right: 10,
                        child: Container(
                          height: 120,
                          width: 200,
                          child: gauges.SfLinearGauge(
                            useRangeColorForAxis: true,
                            ranges: const [
                              //First range
                              //gauges.LinearGaugeRange(startValue: 0, endValue: 50, color: Colors.green, position: gauges.LinearElementPosition.cross,),
                              //Second range
                              //gauges.LinearGaugeRange(startValue: 50, endValue: 100, color: Colors.blue)
                            ],
                            // ni warna pointer yang segi tiga tu
                            markerPointers: [
                              gauges.LinearShapePointer(
                                value:
                                    double.parse(widget.heart_rate.toString()),
                                markerAlignment:
                                    gauges.LinearMarkerAlignment.start,
                                color: Colors.purple,
                              )
                            ],

                            labelFormatterCallback: (value) {
                              if (value == '0') {
                                return 'Low';
                              }
                              if (value == '170') {
                                return 'High';
                              }
                              if (value != '0' || value != '170') {
                                return '';
                              }
                              return value;
                            },

                            showTicks: false,
                            minimum: 0,
                            maximum: 170,

                            axisTrackStyle: const gauges.LinearAxisTrackStyle(
                              edgeStyle: gauges.LinearEdgeStyle.bothCurve,
                              thickness: 15,
                              gradient: LinearGradient(
                                  colors: [Colors.purple, Colors.blue],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  tileMode: TileMode.clamp),
                            ),
                          ),
                        )),
                  ],
                ),
              ),

              // energy burned and heart rate
              const SizedBox(
                height: 15,
              ),

              appointmentReport(),

              const SizedBox(
                height: 15,
              ),

              medicationReport()
            ],
          ),
        ),
      ),
    );
  }
}
