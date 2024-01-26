import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/models/historyLog.dart';
import 'package:seniorconnect/screens/elderlyScreen/reportElderly.dart';
import 'package:seniorconnect/widgets/reportWidget/appointmentCalendar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

class appointmentReport extends StatefulWidget {
  @override
  State<appointmentReport> createState() => _appointmentReportState();
}

class _appointmentReportState extends State<appointmentReport> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('appointmentLog').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No track of any appointment'),
          );
        } else {
          List<logHistory> logger = [];
          final loadedData = snapshot.data!.docs;

          //DateTime.fromMillisecondsSinceEpoch(log['time'] * 1000);
          for (var log in loadedData) {
            Timestamp timestamp = log['time'];
            DateTime dateTime = timestamp.toDate();
            logger.add(logHistory(
                name: log['name'], status: log['status'], time: dateTime));
            //print('time ${log['time']}');
          }

          int attend = 0;
          int skip = 0;

          for (int i = 0; i < logger.length; i++) {
            if (logger[i].status == 'skip') {
              skip++;
            } else {
              attend++;
            }
          }

          double percentage = (attend / (skip + attend)) * 100;

          final List<ChartData2> circleGraph = [
            ChartData2(
                'Attend', double.parse(attend.toString()), Colors.purple),
            ChartData2('Skip', double.parse(skip.toString()),
                Color.fromARGB(135, 231, 173, 173))
          ];

          return Container(
            height: 170,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 10.0, color: Color.fromARGB(30, 0, 0, 0))
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
                      'Appointment',
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
                        builder: (context) =>
                            appointmentCalendar(title: 'Calendar'),
                      ));
                    },
                    child: Text(
                      'History Calendar >',
                      style: GoogleFonts.lexend(
                          fontSize: 12, color: Color.fromARGB(251, 61, 61, 61)),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                      height: 120,
                      width: 120,
                      child:
                          Lottie.asset('lib/assets/lottie/appointment.json')),
                ),
                Positioned(
                    left: 215,
                    top: 70,
                    child: CircleAvatar(
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: GoogleFonts.lexend(
                            fontSize: 15, color: Colors.black),
                      ),
                      backgroundColor: Colors.white,
                    )),
                Positioned(
                  left: 60,
                  top: 40,
                  child: Container(
                      height: 100,
                      width: 350,
                      child: charts.SfCircularChart(
                        legend: const charts.Legend(
                          isVisible:
                              true, // Set to true to make the legend visible
                          overflowMode: charts.LegendItemOverflowMode.wrap,
                          alignment: charts.ChartAlignment
                              .center, // Optional: configures how legend items are displayed
                          position: charts.LegendPosition.right,
                          offset: Offset(20, 10),
                          itemPadding: 15,
                        ),
                        series: <charts.CircularSeries>[
                          charts.DoughnutSeries<ChartData2, String>(
                            innerRadius: '75%',
                            //cornerStyle: charts.CornerStyle.bothCurve,
                            dataSource: circleGraph,

                            //dataLabelSettings: ,
                            pointColorMapper: (ChartData2 data, _) =>
                                data.color,
                            xValueMapper: (ChartData2 data, _) => data.x,
                            yValueMapper: (ChartData2 data, _) => data.y,
                            radius:
                                '130%', // Adjusted radius for better visual appeal
                          ),
                        ],
                      )),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
