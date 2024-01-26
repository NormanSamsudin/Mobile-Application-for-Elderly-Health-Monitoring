import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/models/healthData.dart';
import 'package:seniorconnect/widgets/reportWidget/heartRateFullReport.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class heartRateReport extends StatefulWidget {
  heartRateReport(this.heartList, this.userType);
  List<HealthData> heartList;
  final String userType;

  @override
  State<heartRateReport> createState() => _heartRateReportState();
}

class _heartRateReportState extends State<heartRateReport> {
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.userType == 'elderly') {
      // untuk starting jer kene add satu kali
      // var value = 60 + Random().nextDouble() * (80 - 60);
      //   //
      //   print('Heart Rate ${value}');
      //   // APPEND LIST
      // widget.heartList.add(HealthData(
      //     type: 'HEART_RATE',
      //     value: 60,
      //     unit: '',
      //     dateFrom: DateTime.now().subtract(Duration(seconds: 1)),
      //     //dateTo: DateTime.now().add(Duration(minutes: 1))));
      //     dateTo: DateTime.now().subtract(Duration(seconds: 1))));
      print('last first ${widget.heartList.last.dateFrom.toString()}');

      // widget.heartList = widget.heartList.where((healthData) {
      //   // Define the desired date range (e.g., within the last 24 hours)
      //   DateTime currentDate = DateTime.now();
      //   DateTime twentyFourHoursAgo = DateTime(DateTime.now().year,
      //       DateTime.now().month, DateTime.now().day, 0, 0);

      //   // Check if dateFrom and dateTo fall within the desired range
      //   return healthData.dateFrom.isAfter(twentyFourHoursAgo) &&
      //       healthData.dateTo.isBefore(currentDate);
      // }).toList();

      //sendPushNotification();
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        var value = 60 + Random().nextDouble() * (80 - 60);
        setState(() {
          //emergency
          if (widget.heartList.length > 20 && widget.heartList.length < 80) {
            value = value + 80;
          }

          print('Heart Rate ${value}');
          // APPEND LIST
          widget.heartList.add(HealthData(
              type: 'HEART_RATE',
              value: value,
              unit: '',
              dateFrom: DateTime.now(),
              dateTo: DateTime.now()));

          // widget.heartList.insert(
          //     widget.heartList.length,
          //     HealthData(
          //         type: 'HEART_RATE',
          //         value: value,
          //         unit: '',
          //         dateFrom: DateTime.now(),
          //         dateTo: DateTime.now()));

          print('length ${widget.heartList.length}');

          updateRealTimeDatabase(value);
        });
      });
    }
  }

  void updateRealTimeDatabase(double value) async {
    final url = Uri.https(
        'seniorconnect-f67ed-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/healthData.json'); // not complete url

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'heart_rate': value,
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    color.add(const Color.fromARGB(255, 255, 87, 75));

    final List<double> stops = <double>[];

    stops.add(1.0);
    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);

    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 10.0, color: const Color.fromARGB(30, 0, 0, 0))
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
                child: Lottie.asset('lib/assets/lottie/heart_rate.json')),
          ),
          Positioned(
              top: 45,
              left: 100,
              child: Text(
                '${widget.heartList[widget.heartList.length - 1].value.toStringAsFixed(0)}',
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
                  markerPointers: [
                    gauges.LinearShapePointer(
                      value: double.parse(widget
                          .heartList[widget.heartList.length - 1].value
                          .toString()),
                      markerAlignment: gauges.LinearMarkerAlignment.start,
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
          Positioned(
              top: 100,
              left: 15,
              child: Container(
                height: 150,
                width: 380,
                child: Center(
                  child: charts.SfCartesianChart(
                      borderColor: Colors.white,
                      //backgroundColor: Colors.greenAccent,
                      plotAreaBorderWidth: 0,
                      primaryXAxis: charts.DateTimeAxis(
                        labelStyle:
                            TextStyle(color: Color.fromARGB(107, 0, 0, 0)),
                        axisLine: const charts.AxisLine(width: 0),
                        majorGridLines: charts.MajorGridLines(width: 0),
                        borderWidth: 0,
                        borderColor: Colors.white,
                        isVisible: true,
                        minimum: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 0),
                        maximum: DateTime.now(),
                      ),
                      primaryYAxis: const charts.NumericAxis(
                          borderWidth: 0,
                          axisBorderType: charts.AxisBorderType.rectangle,
                          axisLine: charts.AxisLine(
                              width: 0.5,
                              color: Color.fromARGB(198, 244, 67, 54)),
                          majorGridLines: charts.MajorGridLines(
                            width: 0.5,
                            //color: Color.fromARGB(198, 244, 67, 54)
                          ),
                          borderColor: Colors.black,
                          minimum: 0,
                          maximum: 190,
                          labelStyle:
                              TextStyle(color: Color.fromARGB(107, 0, 0, 0)),
                          isVisible: true),
                      //title: ChartTitle(text: 'Heart Rate Reading'),

                      series: <charts.AreaSeries>[
                        // Renders line chart
                        charts.AreaSeries<HealthData, DateTime>(
                          //color: Colors.red,
                          //width: 2,
                          //opacity: 0.6,

                          dataSource: widget.heartList,
                          xValueMapper: (HealthData heart_rate, _) =>
                              heart_rate.dateFrom,
                          yValueMapper: (HealthData heart_rate, _) =>
                              heart_rate.value,
                          gradient: gradientColors,
                          //isVisibleInLegend: true,
                          //isVisible: true,
                          //xAxisName: 'Time',
                          //yAxisName: 'Heart Rate',
                        )
                      ]),
                ),
              )),
        ],
      ),
    );
  }
}
