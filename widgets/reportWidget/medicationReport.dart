import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/models/historyLog.dart';
import 'package:seniorconnect/screens/elderlyScreen/reportElderly.dart';
import 'package:seniorconnect/widgets/reportWidget/medicationHistory.dart';
import 'package:seniorconnect/widgets/reportWidget/medicineCircle.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

class medicationReport extends StatefulWidget {
  @override
  State<medicationReport> createState() => _medicationReportState();
}

class _medicationReportState extends State<medicationReport> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('medicationLog').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Track of any medication'),
            );
          } else {
            List<logHistory> logger = [];
            final loadedData = snapshot.data!.docs;

            int mon = 0;
            int tue = 0;
            int wed = 0;
            int thu = 0;
            int fri = 0;
            int sat = 0;
            int sun = 0;

            List<String> daysOfWeek = [
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
              "Friday",
              "Saturday",
              "Sunday"
            ];

            //full array
            for (var log in loadedData) {
              Timestamp timestamp = log['time'];
              DateTime dateTime = timestamp.toDate();
              logger.add(logHistory(
                  name: log['name'], status: log['status'], time: dateTime));

              // String dayName = daysOfWeek[dateTime.weekday - 1];

              // if (dayName == 'Monday') {
              //   mon++;
              // }
              // if (dayName == 'Tuesday') {
              //   tue++;
              // }
              // if (dayName == 'Wednesday') {
              //   wed++;
              // }
              // if (dayName == 'Friday') {
              //   fri++;
              // }
              // if (dayName == 'Saturday') {
              //   sat++;
              // }
              // if (dayName == 'Sunday') {
              //   sun++;
              // }
            }

            DateTime now = DateTime.now();
            int currentWeekday = now.weekday;

            DateTime startOfWeek =
                now.subtract(Duration(days: currentWeekday - 1));
            DateTime endOfWeek = now.add(Duration(days: 7 - currentWeekday));

            //filtered array untuk current week only
            List<logHistory> filteredObjects = logger.where((obj) {
              return obj.time
                      .isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                  obj.time.isBefore(endOfWeek);
            }).toList();

            for (var log in filteredObjects) {
              DateTime dateTime = log.time;

              String dayName = daysOfWeek[dateTime.weekday - 1];
              print(dayName);
              print('date $dayName');

              if (dayName == 'Monday') {
                mon++;
              }
              if (dayName == 'Tuesday') {
                tue++;
              }
              if (dayName == 'Wednesday') {
                wed++;
              }
              if (dayName == 'Thursday') {
                thu++;
              }
              if (dayName == 'Friday') {
                fri++;
              }
              if (dayName == 'Saturday') {
                sat++;
              }
              if (dayName == 'Sunday') {
                sun++;
              }
            }

            final List<ChartData> chartData2 = [
              ChartData(day: 'Sun', qtt: sun),
              ChartData(day: 'Mon', qtt: mon),
              ChartData(day: 'Tue', qtt: tue),
              ChartData(day: 'Wed', qtt: wed),
              ChartData(day: 'Thu', qtt: thu),
              ChartData(day: 'Fri', qtt: fri),
              ChartData(day: 'Sat', qtt: sat),
            ];

            return Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10.0, color: Color.fromARGB(30, 0, 0, 0))
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
                        'Medication',
                        style: GoogleFonts.lexend(
                          fontSize: 18,
                        ),
                      )),
                  Positioned(
                    top: 15,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => medicationHistory(),
                        ));
                      },
                      child: Text(
                        'Weekly Report >',
                        style: GoogleFonts.lexend(
                            fontSize: 12,
                            color: Color.fromARGB(251, 61, 61, 61)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 25,
                    child: Container(
                        height: 80,
                        width: 80,
                        child:
                            Lottie.asset('lib/assets/lottie/medication.json')),
                  ),
                  Positioned(
                      right: 10,
                      top: 20,
                      child: Container(
                        height: 120,
                        width: 300,
                        child: charts.SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          borderWidth: 0,
                          borderColor: Colors.white,
                          primaryXAxis: const charts.CategoryAxis(
                            borderWidth: 0,
                            axisLine: charts.AxisLine(
                                width: 0, dashArray: <double>[100, 100]),
                            majorGridLines: charts.MajorGridLines(width: 0),
                            borderColor: Colors.white,
                            isVisible: true,
                          ),
                          primaryYAxis: const charts.NumericAxis(
                              borderWidth: 0,
                              axisLine: const charts.AxisLine(width: 0),
                              majorGridLines:
                                  const charts.MajorGridLines(width: 0),
                              borderColor: Colors.white,
                              isVisible: false,
                              minorGridLines:
                                  const charts.MinorGridLines(width: 0),
                              minimum: 0,
                              minorTickLines:
                                  const charts.MinorTickLines(width: 0)),
                          series: <charts.CartesianSeries<ChartData, String>>[
                            // Renders column chart
                            charts.ColumnSeries<ChartData, String>(
                                color: Colors.purple,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                trackBorderWidth: 5,
                                borderWidth: 15,
                                width: 0.3,
                                dataSource: chartData2,
                                xValueMapper: (ChartData data, _) => data.day,
                                yValueMapper: (ChartData data, _) => data.qtt)
                          ],
                          tooltipBehavior: charts.TooltipBehavior(enable: true),
                        ),
                      )),
                ],
              ),
            );
          }
        });
  }
}
