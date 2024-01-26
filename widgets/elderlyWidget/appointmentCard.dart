import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/models/appointment.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final List<Appointment> nextAppointments;

  AppointmentCard({
    Key? key,
    required this.nextAppointments,
  }) : super(key: key);

  void absentActionLog(BuildContext context, String id, String name) async {
    try {
      var uuid = Uuid();
      // add data dalam log
      await FirebaseFirestore.instance
          .collection('appointmentLog')
          .doc(id)
          .set({
        'id': uuid.v1(),
        'name': name,
        'status': 'absent',
        'time': DateTime.now()
      });

      //update data in existing table
      await FirebaseFirestore.instance
          .collection('appointment')
          .doc(id)
          .delete();
    } on FirebaseFirestore catch (error) {
      // kalau ada error nnti die akan show snackbar dekat bahagian bawah dgn error apa yang ada
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  void attendActionLog(BuildContext context, String id, String name) async {
    try {
      var uuid = Uuid();
      // add data dalam log
      await FirebaseFirestore.instance
          .collection('appointmentLog')
          .doc(id)
          .set({
        'id': uuid.v1(),
        'name': name,
        'status': 'attend',
        'time': DateTime.now()
      });

      //update data in existing table
      await FirebaseFirestore.instance
          .collection('appointment')
          .doc(id)
          .delete();
    } on FirebaseFirestore catch (error) {
      // kalau ada error nnti die akan show snackbar dekat bahagian bawah dgn error apa yang ada
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {



    return ListView.builder(
      itemCount: nextAppointments.length,
      itemBuilder: (context, index) {
        Appointment appointment = nextAppointments[index];
        bool isFirstIndex = index == 0; // Check if it's the first index
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, ),
          child: Card(
            //elevation: 4.0,
            child: Column(
              children: [
                ListTile(
                  title: Text(appointment.place, 
                    style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),),
                  subtitle: Text('${DateFormat('yyyy-MM-dd').format(appointment.date.toDate())} ${DateFormat('h:mm a').format(appointment.date.toDate())}',style: GoogleFonts.lexend(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(168, 53, 53, 53))),//date
                  trailing: Icon(Icons.favorite_outline),
                ),
                const Divider(
                  color: Color.fromARGB(91, 37, 36, 36),
                  height: 25,
                  thickness: 0.75,
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                  height: 250.0,
                  child: Image.asset(
                      'lib/assets/hospital/${appointment.place}.png'),
                ),
                const Divider(
                  color: Color.fromARGB(91, 37, 36, 36),
                  height: 25,
                  thickness: 0.75,
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 5, right: 20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Purpose',
                                style: GoogleFonts.lexend(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),),
                      Text(appointment.name,
                                style: GoogleFonts.lexend(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue),),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Caregiver Responsible',
                                style: GoogleFonts.lexend(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),),
                      Text('${appointment.accompany}',
                                style: GoogleFonts.lexend(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue),)
                    ],
                  ),
                ),
                SizedBox(height: 15,)
                // ButtonBar(
                //   children: [
                //     isFirstIndex
                //         ? TextButton(
                //             child: const Text(
                //               'ABSENT',
                //               style: TextStyle(color: Colors.red),
                //             ),
                //             onPressed: () {
                //               absentActionLog(
                //                   context, appointment.id, appointment.name);
                //             },
                //           )
                //         : const Padding(
                //             padding: EdgeInsets.only(
                //               bottom: 20,
                //             ),
                //             child: Text(
                //               'ABSENT',
                //               style: TextStyle(color: Colors.grey),
                //             ),
                //           ),
                //     isFirstIndex
                //         ? TextButton(
                //             child: const Text(
                //               'ATTEND',
                //               style: TextStyle(color: Colors.green),
                //             ),
                //             onPressed: () {
                //               attendActionLog(
                //                   context, appointment.id, appointment.name);
                //             },
                //           )
                //         : const Padding(
                //             padding: EdgeInsets.only(
                //                 bottom: 20, left: 10, right: 10),
                //             child: Text(
                //               'ATTEND',
                //               style: TextStyle(color: Colors.grey),
                //             )),
                //   ],
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
