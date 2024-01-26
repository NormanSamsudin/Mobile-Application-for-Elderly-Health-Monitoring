import 'dart:math';

import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/data/dummy_data.dart';
import 'package:seniorconnect/models/historyLog.dart';
import 'package:seniorconnect/service/home_controller.dart';
import 'package:seniorconnect/models/healthData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/widgets/reportWidget/appointmentReport.dart';
import 'package:seniorconnect/widgets/reportWidget/googleFit/bloodGlucoseReport.dart';
import 'package:seniorconnect/widgets/reportWidget/googleFit/heartRateReport.dart';
import 'package:seniorconnect/widgets/reportWidget/medicationReport.dart';
import 'package:seniorconnect/widgets/reportWidget/googleFit/temperatureReport.dart';
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:seniorconnect/service/generatePdf.dart';

class reportElderly extends StatefulWidget {
  const reportElderly({super.key});

  @override
  State<reportElderly> createState() => _HomepageState();
}

class _HomepageState extends State<reportElderly> {
  //chart key
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  


  final controller = HomeController();
  late Timer _timer;
  List<HealthData> blood_glucose = [];
  List<HealthData> heart_rate = [];
  List<HealthData> body_temperature = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getData();

    heart_rate.addAll(heart_rate_dummy);
    print('array added');
    print('array ${heart_rate.length}');

    blood_glucose.add(HealthData(
        type: 'BLOOD_GLUCOSE',
        value: 6.8,
        unit: '',
        dateFrom: DateTime.now(),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))));

    body_temperature.add(HealthData(
        type: 'BODY_TEMPERATURE',
        value: 36.5,
        unit: '',
        dateFrom: DateTime.now(),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))));
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // HealthDataType.BLOOD_GLUCOSE,
    // HealthDataType.STEPS,
    // HealthDataType.HEART_RATE,
    // HealthDataType.ACTIVE_ENERGY_BURNED,
    // HealthDataType.BODY_TEMPERATURE,

    final List<ChartData2> circleGraph = [
      ChartData2('Attend', 2, Colors.purple),
      ChartData2('Skip', 1, Color.fromARGB(136, 200, 195, 195))
    ];

    final List<Color> color = <Color>[];
    color.add(Colors.red[50]!);
    color.add(Colors.red[200]!);
    color.add(Colors.red);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 76, 8, 88)),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SeniourConnect',
              style: TextStyle(color: Color.fromARGB(255, 76, 8, 88)),
            ),
            SizedBox(
              width: 40,
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkCyan, tiffany_blue],
          ),
        ),
        child: ValueListenableBuilder(
            valueListenable: controller.healthData,
            builder: (context, value, child) {
              for (var data in value) {
                if (data.type == 'BLOOD_GLUCOSE') {
                  blood_glucose.add(data);
                }
                if (data.type == 'HEART_RATE') {
                  //heart_rate.add(data);
                }
                if (data.type == 'BODY_TEMPERATURE') {
                  body_temperature.add(data);
                }
              }

              if (heart_rate.length == 0 ||
                  blood_glucose.length == 0 ||
                  body_temperature.length == 0) {
                return const Center(
                  child: Text(
                    'Retrieving data',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromRGBO(59, 169, 156, 1),
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Elderly Dashboard,',
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
                                RepaintBoundary(
                                  key: key4,
                                  child: temperatureReport(body_temperature, 'elderly')),
                                RepaintBoundary(
                                  key: key5,
                                  child: bloodGlucoseReport(blood_glucose, 'elderly'))
                              ],
                            ),
                          

                          const SizedBox(
                            height: 10,
                          ),

                          RepaintBoundary(
                            key: key3 ,
                            child: heartRateReport(heart_rate, 'elderly')),

                          const SizedBox(
                            height: 10,
                          ),

                          //custom widget
                          RepaintBoundary(
                            key: key1,
                            child: appointmentReport()),

                          const SizedBox(
                            height: 10,
                          ),

                          RepaintBoundary(
                            key: key2,
                            child: medicationReport())
                        ],
                      )),
                );
              }
            }),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.download),
      //   onPressed: () async {
      //     pdfGenerator pdf = pdfGenerator(key1, key2, key3, key4, key5);
      //     await pdf.createPDF();
      //   },
      // ),
    );
  }
}

class ChartData {
  ChartData({required this.day, required this.qtt});
  final String day;
  final int qtt;
}

class ChartData2 {
  ChartData2(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
