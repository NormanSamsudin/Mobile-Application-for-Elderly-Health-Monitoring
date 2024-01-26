import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/data/dummy_data.dart';
import 'package:seniorconnect/models/appointment.dart';
import 'package:seniorconnect/models/medication.dart';
// import 'package:seniorconnect/rubbish/add_appointment.dart';
import 'package:seniorconnect/widgets/elderlyWidget/appointmentCard.dart';
// import 'package:seniorconnect/rubbish/next_appointment.dart';
// import 'package:seniorconnect/rubbish/upcoming_appointment.dart';

class appointmentElderly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('appointment'),
      //   backgroundColor: tiffany_blue,
      // ),
      body: StreamBuilder(
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
              // return Center(
              //   child: Column(
              //     children: [
              //       Spacer(),
              //       Text('No Appointment Added'),
              //       IconButton(
              //           onPressed: () {
              //             Navigator.of(context).push(MaterialPageRoute(
              //               builder: (context) => addAppointment(),
              //             ));
              //           },
              //           icon: Icon(Icons.abc)),
              //       Spacer()
              //     ],
              //   ),
              // );
              return Scaffold(
                appBar: AppBar(
                  iconTheme:
                      IconThemeData(color: Color.fromARGB(255, 76, 8, 88)),
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Appointment',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 8, 88),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                  backgroundColor: Colors.white,
                ),
                body: Container(
                  decoration: const BoxDecoration(
                  color: Color.fromRGBO(59, 169, 156, 1),
                ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 220,),
                        Container(
                          height: 300,
                          width: 300,
                          child: Lottie.asset('lib/assets/lottie/complete.json')),
                          Container(
                            width: 250,
                            child: Text('Congratulation you have complete your appointments !!!', style: GoogleFonts.lexend( fontSize: 15, color: Colors.white), textAlign: TextAlign.center),),
                          const Spacer()
                
                    ]
                    ),),
                ),
                  
              );
            }

            //kalau ada data
            else {
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

              var filteredData = listAppointment
                  .where((element) => element.status == '')
                  .toList();
              return Scaffold(
                backgroundColor: Color.fromRGBO(59, 169, 156, 1),
                appBar: AppBar(
                  iconTheme:
                      IconThemeData(color: Color.fromARGB(255, 76, 8, 88)),
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Appointment',
                        style: TextStyle(
                          color: Color.fromARGB(255, 76, 8, 88),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                  backgroundColor: Colors.white,
                ),
                body: AppointmentCard(nextAppointments: listAppointment),
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () {
                //     // Add your action here
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => addAppointment(),
                //     ));
                //   },
                //   child: Icon(Icons.add), // You can change the icon
                //   backgroundColor: Colors.blue, // You can change the color
                // ),
              );
            }
          }),
    );
  }
}
