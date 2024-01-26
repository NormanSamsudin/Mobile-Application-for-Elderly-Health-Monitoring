import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/data/dummy_data.dart';
import 'package:seniorconnect/models/appointment.dart';
import 'package:seniorconnect/models/medication.dart';
import 'package:seniorconnect/screens/addScreen/add_appointment.dart';

import 'package:seniorconnect/widgets/caregiverWidget/appointmentCard.dart';
// import 'package:seniorconnect/rubbish/next_appointment.dart';
// import 'package:seniorconnect/rubbish/upcoming_appointment.dart';

class appointment extends StatelessWidget {
  appointment({super.key, required this.openDrawer});

  final void Function() openDrawer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // dah collect data sambil sort data yang dah ada
        stream: FirebaseFirestore.instance
            .collection('appointment')
            .orderBy('dateTime', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // kalau takde data dalam collection
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Scaffold(
              backgroundColor: Color.fromRGBO(59, 169, 156, 1),
              appBar: AppBar(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Appointment',
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 8, 88),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
              ),
              body: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(59, 169, 156, 1),
                ),
                child: Center(
                  child: Column(children: [
                    const SizedBox(
                      height: 220,
                    ),
                    Container(
                        height: 300,
                        width: 300,
                        child: Lottie.asset('lib/assets/lottie/complete.json')),
                    Container(
                      width: 250,
                      child: Text(
                          'Congratulation you have complete your appointments !!!',
                          style: GoogleFonts.lexend(
                              fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                    const Spacer()
                  ]),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add your action here
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => addAppointment(),
                  ));
                },
                child: Icon(Icons.add), // You can change the icon
                backgroundColor: Color.fromARGB(
                    255, 247, 201, 255), // You can change the color
              ),
            );
          } else {
            List<Appointment> listAppointment = [];
            print(snapshot.data);

            final loadedData = snapshot.data!.docs;

            // nak convert data yang dah collected daripada database ke dalam array form
            for (var appt in loadedData) {
              listAppointment.add(Appointment(
                  id: appt['id'],
                  name: appt['name'],
                  place: appt['place'],
                  date: appt['dateTime'],
                  accompany: appt['accompany'],
                  status: ''));
            }
            return Scaffold(
              backgroundColor: Color.fromRGBO(59, 169, 156, 1),
              appBar: AppBar(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Appointment',
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 8, 88),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
              ),
              body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(59, 169, 156, 1),
                  ),
                  child: ListView(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Text(
                        'List of Appointment',
                        style: GoogleFonts.lexend(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height - 220,
                        child:
                            AppointmentCard(nextAppointments: listAppointment))
                  ])),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add your action here
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => addAppointment(),
                  ));
                },
                child: Icon(Icons.add), // You can change the icon
                backgroundColor: Color.fromARGB(
                    255, 247, 201, 255), // You can change the color
              ),
            );
          }
        });
  }
}
