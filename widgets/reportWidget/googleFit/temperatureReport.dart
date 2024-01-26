import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:seniorconnect/models/healthData.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class temperatureReport extends StatefulWidget {
  temperatureReport(
    this.tempList,
    this.userType
  );

  final List<HealthData> tempList;
  final String userType;

  @override
  State<temperatureReport> createState() => _temperatureReportState();
}

class _temperatureReportState extends State<temperatureReport> {
  late Timer _timer;

  @override
  void initState() {

    super.initState();
    if( widget.userType == 'elderly'){
          _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        //
        print('done');  

        double value = 36.1 + Random().nextDouble() * (37.0 - 36.1);

        // APPEND LIST
        widget.tempList.add(HealthData(
            type: 'BODY_TEMPERATURE',
            value: value,
            unit: '',
            dateFrom: DateTime.now(),
            dateTo: DateTime.now().add(Duration(seconds: 5))));

        updateRealTimeDatabase(value);
      });
    });
    }

  }

  void updateRealTimeDatabase(double number) async {
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
          'body_temperature': number,
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
          BoxShadow(blurRadius: 10.0, color: const Color.fromARGB(20, 0, 0, 0))
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
                child: Lottie.asset('lib/assets/lottie/temperature.json')),
          ),
          Positioned(
              top: 65,
              right: 40,
              child: Text(
                '${widget.tempList[widget.tempList.length - 1].value.toStringAsFixed(1)}',
                style: GoogleFonts.lexend(
                    fontSize: 35, color: Color.fromARGB(158, 0, 0, 0)),
              )),
          Positioned(
              top: 60,
              right: 20,
              child: Text(
                '°C',
                style: GoogleFonts.lexend(
                    fontSize: 15, color: Color.fromARGB(158, 0, 0, 0)),
              )),
          if (widget.tempList[widget.tempList.length - 1].value > 36.1 &&
              widget.tempList[widget.tempList.length - 1].value < 37.2)
            Positioned(
              top: 100,
              right: 20,
              child: Text(
                'Normal',
                style: GoogleFonts.lexend(
                    fontSize: 18, color: const Color.fromARGB(158, 0, 0, 0)),
              ),
            ),
          if (widget.tempList[widget.tempList.length - 1].value > 37.2)
            Positioned(
              top: 100,
              right: 20,
              child: Text(
                'Low',
                style: GoogleFonts.lexend(
                    fontSize: 18, color: const Color.fromARGB(158, 0, 0, 0)),
              ),
            ),
          if (widget.tempList[widget.tempList.length - 1].value < 36.1)
            Positioned(
              top: 100,
              right: 20,
              child: Text(
                'High',
                style: GoogleFonts.lexend(
                    fontSize: 18, color: const Color.fromARGB(158, 0, 0, 0)),
              ),
            ),
          
        ],
      ),
    );
  }
}
