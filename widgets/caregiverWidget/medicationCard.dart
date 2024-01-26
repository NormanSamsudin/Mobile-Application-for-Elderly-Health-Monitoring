import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/models/appointment.dart';
import 'package:seniorconnect/models/medication.dart';
import 'package:seniorconnect/screens/editScreen/edit_appointment.dart';
import 'package:seniorconnect/screens/editScreen/edit_medication.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class medicationCard extends StatelessWidget {
  final List<Medication> nextMedication;

  medicationCard({
    Key? key,
    required this.nextMedication,
  }) : super(key: key);

  void absentActionLog(BuildContext context, String id, String name) async {
    try {
      // print('string id $id');
      // await FirebaseFirestore.instance
      //     .collection('medication')
      //     .doc(id)
      //     .delete();

      var uuid = Uuid();
      // add data dalam log
      await FirebaseFirestore.instance.collection('medicationLog').doc(id).set({
        'id': uuid.v1(),
        'name': name,
        'status': 'skip',
        'time': DateTime.now()
      });

      //update data in existing table
      await FirebaseFirestore.instance
          .collection('medication')
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
      await FirebaseFirestore.instance.collection('medicationLog').doc(id).set({
        'id': uuid.v1(),
        'name': name,
        'status': 'taken',
        'time': DateTime.now()
      });

      //update data in existing table
      await FirebaseFirestore.instance
          .collection('medication')
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

  void deleteMedicationCollection(BuildContext context, String id) async {
    try {
      //update data in existing table
      await FirebaseFirestore.instance
          .collection('medication')
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

  void accompany(BuildContext context, String id) async {
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .get();

      if (response.exists) {
        var userData = response.data();
        String name = userData!['username'];
        print('current user ${name}');

        //update data in existing table
        await FirebaseFirestore.instance
            .collection('appointment')
            .doc(id)
            .update({'accompany': name});
      } else {
        print('no data');
        return;
      }
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

  void triggerNotifyElderly() async {
    var response = await FirebaseFirestore.instance
        .collection('triggers')
        .doc('trigger_remind_elderly_medication')
        .update({'last_reminder': DateTime.now()});
  }

  @override
  Widget build(BuildContext context) {
    // kalau medication die untuk haritu dah habis
    if (nextMedication.length == 0) {
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
                'Elderly have completed the medication for today !!!',
                style: GoogleFonts.lexend(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center),
          ),
          const Spacer()
        ]),
      );
    }

    return ListView.builder(
      itemCount: nextMedication.length,
      itemBuilder: (context, index) {
        Medication medication = nextMedication[index];
        bool isFirstIndex = index == 0; // Check if it's the first index
        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Card(
            elevation: 4,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                            height: 35,
                            child: Image.asset('lib/assets/images/meds.png')),
                        Text(
                          ' ${medication.name}',
                          style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                    width: 96,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        InkWell(
                          child: Container(
                            height: 30,
                            child: Icon(Icons.delete),
                          ),
                          onTap: () {
                            deleteMedicationCollection(context, medication.id);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Container(
                            height: 30,
                            child: Icon(Icons.edit),
                          ),
                          onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    editMedicationV2(medication: medication),
                              ));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(91, 37, 36, 36),
                  height: 5,
                  thickness: 0.75,
                  indent: 20,
                  endIndent: 20,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 13, left: 20, right: 20, bottom: 13),
                    child: Image.asset(
                      'lib/assets/medicine/${medication.name}.png',
                      height: 150,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(91, 37, 36, 36),
                  height: 5,
                  thickness: 0.75,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 18,
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                              Text(
                                'Time schedule:',
                                style: GoogleFonts.lexend(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text('${DateFormat('h:mm a').format(medication.startTime)}',
                              style: GoogleFonts.lexend(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(168, 53, 53, 53)))
                          //   ],
                          // ),
                        ],
                      ),
                      Spacer(),
                      isFirstIndex
                          ? Container(
                              height: 37,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color.fromARGB(
                                        255, 106, 187, 246), // Lighter shade
                                    tiffany_blue, // Your original color
                                    Color(0xFF026890), // Darker shade
                                  ],
                                  stops: [0.0, 0.15, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextButton.icon(
                                  onPressed: () {
                                    triggerNotifyElderly();
                                  },
                                  icon: const Icon(
                                    Icons.notifications_active,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Remind Elderly',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(
                                  right: 8, top: 13, bottom: 15),
                              child: Text(
                                'Remind Elderly',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(105, 0, 0, 0)),
                              ),
                            ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),

                    Padding(
                    padding: const EdgeInsets.only(
                    top: 10,
                    left: 18,
                  ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity:',
                            style: GoogleFonts.lexend(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Text('${medication.quantity}',  style: GoogleFonts.lexend(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(168, 53, 53, 53)))
                        ],
                      ),
                    ),

                Container(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
