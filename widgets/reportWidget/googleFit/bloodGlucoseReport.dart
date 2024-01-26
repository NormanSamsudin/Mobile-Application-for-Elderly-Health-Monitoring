import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/models/healthData.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauges;
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class bloodGlucoseReport extends StatefulWidget {
  bloodGlucoseReport(
    this.bloodList,
    this.userType,
  );

  final List<HealthData> bloodList;
  final String userType;

  @override
  State<bloodGlucoseReport> createState() => _bloodGlucoseReportState();
}

class _bloodGlucoseReportState extends State<bloodGlucoseReport> {
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.userType == 'elderly') {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        setState(() {
          //
          print('done');

          // APPEND LIST
          widget.bloodList.add(HealthData(
              type: 'BLOOD_GLUCOSE',
              value: 5 + Random().nextDouble() * (7.8 - 5),
              unit: '',
              dateFrom: DateTime.now(),
              dateTo: DateTime.now().add(Duration(seconds: 5))));

          updateRealTimeDatabase();
        });
      });
    }
  }

  void updateRealTimeDatabase() async {
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
          //'blood_glucose': controller.healthData.toJS.toString(),
          //'steps': steps.toList().toJS.toString(),
          'blood_glucose': widget.bloodList[widget.bloodList.length - 1].value,
          // 'blood_glucose': blood_glucose[blood_glucose.length - 1].value,
          // 'active_energy_bured':
          //     energy_burned[energy_burned.length - 1].value,
          // 'body_temperature':
          //     body_temperature[body_temperature.length - 1].value,
          // 'sleep' : sleep[sleep.length - 1].value,
          // 'active_energy_burned' : energy_burned.toString(),
          // 'body_temperature' : body_temperature.toString(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 150,
        width: MediaQuery.sizeOf(context).width/2 - 20,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 10.0, color: const Color.fromARGB(20, 0, 0, 0))
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
              left: 12,
              child: Container(
                  height: 80,
                  width: 80,
                  child: Lottie.asset('lib/assets/lottie/blood.json')),
            ),

            Positioned(
                top: 65,
                right: 40,
                child: Text(
                  '${widget.bloodList[widget.bloodList.length - 1].value.toStringAsFixed(1)}',
                  style: GoogleFonts.lexend(
                      fontSize: 35, color: Color.fromARGB(158, 0, 0, 0)),
                )),

            Positioned(
                top: 55,
                right: 20,
                child: Text(
                  'mmol/L',
                  style: GoogleFonts.lexend(
                      fontSize: 15, color: Color.fromARGB(158, 0, 0, 0)),
                )),

            //normal range (3.9 - 5.6)
            if (widget.bloodList[widget.bloodList.length - 1].value < 7.8)
              Positioned(
                top: 100,
                right: 30,
                child: Text(
                  'Normal',
                  style: GoogleFonts.lexend(
                      fontSize: 18, color: const Color.fromARGB(158, 0, 0, 0)),
                ),
              ),

            if (widget.bloodList[widget.bloodList.length - 1].value >= 7.8)
              Positioned(
                top: 100,
                right: 30,
                child: Text(
                  'High',
                  style: GoogleFonts.lexend(
                      fontSize: 18, color: const Color.fromARGB(158, 0, 0, 0)),
                ),
              ),
          ],
        ));
  }
}
