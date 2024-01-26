import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/models/medication.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationCard extends StatelessWidget {
  final List<Medication> medications;

  MedicationCard({Key? key, required this.medications}) : super(key: key);

  void absentActionLog(BuildContext context, String id, String name) async {
    try {
      // print('string id $id');
      // await FirebaseFirestore.instance
      //     .collection('medication')
      //     .doc(id)
      //     .delete();

      var uuid = Uuid();
      // add data dalam log
      String idNew = uuid.v1();
      await FirebaseFirestore.instance
          .collection('medicationLog')
          .doc(idNew)
          .set({
        'id': uuid.v1(),
        'name': name,
        'status': 'skip',
        'time': DateTime.now()
      });

      //update data in existing table
      await FirebaseFirestore.instance
          .collection('medication')
          .doc(id)
          .update({'status': 'skip'});
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
      String idNew = uuid.v1();
      await FirebaseFirestore.instance
          .collection('medicationLog')
          .doc(idNew)
          .set({
        'id': uuid.v1(),
        'name': name,
        'status': 'taken',
        'time': DateTime.now()
      });

      //update data in existing table
      await FirebaseFirestore.instance
          .collection('medication')
          .doc(id)
          .update({'status': 'taken'});
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
    if (medications.length == 0) {
      return Center(
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
                'Congratulation you have complete your medications for today !!!',
                style: GoogleFonts.lexend(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center),
          ),
          const Spacer()
        ]),
      );
    }

    return ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        Medication medication = medications[index];
        bool isFirstIndex = index == 0; // Check if it's the first index

        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Card(
            elevation: 3.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150.0,
                  height: 200.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                          'lib/assets/medicine/${medication.name}.png'),
                    )),
                  ),
                ),
                // const Divider(
                //   color: Color.fromARGB(91, 37, 36, 36),
                //   height: 200,
                //   thickness: 0.75,
                //   indent: 20,
                //   endIndent: 20,
                // ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, top: 5, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        Text(
                          '${medication.name}',
                          style: GoogleFonts.lexend(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(204, 47, 46, 46)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Start: ${DateFormat('h:mm a').format(medication.startTime)}',
                          style: GoogleFonts.lexend(
                              fontSize: 15, fontWeight: FontWeight.normal, color: Color.fromARGB(204, 73, 72, 72)),
                        ),
                        Text(
                          'End: ${DateFormat('h:mm a').format(medication.endTime)}',
                          style: GoogleFonts.lexend(
                              fontSize: 15, fontWeight: FontWeight.normal, color: Color.fromARGB(204, 73, 72, 72)),
                        ),
                        Text(
                          'Quantity: ${medication.quantity.toString()}',
                          style: GoogleFonts.lexend(
                              fontSize: 15, fontWeight: FontWeight.normal, color: Color.fromARGB(204, 73, 72, 72)),
                        ),
                        ButtonBar(
                          children: [
                            isFirstIndex
                                ? TextButton(
                                    child: const Text(
                                      'SKIP',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      absentActionLog(context, medication.id,
                                          medication.name);
                                    },
                                  )
                                : const Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      'SKIP',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                            isFirstIndex
                                ? TextButton(
                                    child: const Text(
                                      'TAKE',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    onPressed: () {
                                      attendActionLog(context, medication.id,
                                          medication.name);
                                    },
                                  )
                                : const Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20, left: 10, right: 10),
                                    child: Text(
                                      'TAKE',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
