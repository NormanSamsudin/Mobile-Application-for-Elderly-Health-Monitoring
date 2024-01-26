import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:seniorconnect/rubbish/log_numeric.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:seniorconnect/service/streamCaregiverDashboard.dart';
import 'package:seniorconnect/widgets/caregiverWidget/dataDashboard.dart';

class screen2 extends StatefulWidget {
  @override
  State<screen2> createState() => _screen2State();
}

class _screen2State extends State<screen2> {
  final DataStream _dataStream = DataStream();
  Map<String, dynamic> _jsonData = {};

  @override
  void initState() {
    super.initState();
    //execute once page created
    _dataStream.fetchDataFromFirebase();
    // execute periodically for every three seconds
    Timer.periodic(Duration(seconds: 10), (timer) {
      _dataStream.fetchDataFromFirebase();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dataStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Dashboard',
            style: TextStyle(
              color: Color.fromARGB(255, 76, 8, 88),
            ),
          ),
        ]),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _dataStream.dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _jsonData = snapshot.data!;
            //double active_energy_burned = double.parse(_jsonData['active_energy_bured'].toString()) ;
            double blood_glucose =
                double.parse(_jsonData['blood_glucose'].toString());
            double body_temperature =
                double.parse(_jsonData['body_temperature'].toString());
            double heart_rate =
                double.parse(_jsonData['heart_rate'].toString());

            //print('active $active_energy_burned');
            print('glucose $blood_glucose');
            print('temperature $body_temperature');
            print('heart rate $heart_rate');

            return dataDashboard(
                active_energy_burned: 0,
                blood_glucose: blood_glucose,
                body_temperature: body_temperature,
                heart_rate: heart_rate);
          }
          if (!snapshot.hasData) {
            return dataDashboard(
                active_energy_burned: 0,
                blood_glucose: 0,
                body_temperature: 0,
                heart_rate: 0);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
