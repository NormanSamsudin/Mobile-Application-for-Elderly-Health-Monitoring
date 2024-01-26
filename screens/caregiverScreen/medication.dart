import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/data/dummy_data.dart';
import 'package:seniorconnect/models/medication.dart';
import 'package:seniorconnect/screens/addScreen/add_medication.dart';
import 'package:seniorconnect/widgets/caregiverWidget/medicationCard.dart';

class medicationScreenV2 extends StatefulWidget {
  medicationScreenV2({super.key, required this.openDrawer});

  final void Function() openDrawer;

  @override
  State<medicationScreenV2> createState() => _medicationScreenV2State();
}

class _medicationScreenV2State extends State<medicationScreenV2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setupPushNotification();
  }

  // void setupPushNotification() async {
  //   print('request');
  //   final fcm = FirebaseMessaging.instance;
  //   await fcm.requestPermission();
  //   final token = await fcm.getToken();
  //   fcm.subscribeToTopic('caregiver');
  //   print('caregiver Token: ${token}');
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medication')
            .orderBy('startTime', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // kalau takde data dalam collection
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Spacer(),
                  Text('No Medication Added'),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => addMedicationV2(),
                        ));
                      },
                      icon: Icon(Icons.abc)),
                  Spacer()
                ],
              ),
            );
          }

          //kalau ada data
          else {
            //list untuk pass untuk card list medic
            List<Medication> listMedic = [];

            //
            final loadedData = snapshot.data!.docs;

            //nak extract data masukkan dalam list
            for (var med in loadedData) {
              Timestamp start = med['startTime'];
              Timestamp end = med['EndTime'];
              listMedic.add(Medication(
                  id: med['id'],
                  name: med['name'],
                  quantity: med['quantity'],
                  startTime: start.toDate(),
                  endTime: end.toDate(),
                  status: med['status']));
            }

            var filteredData =
                listMedic.where((item) => item.status == '').toList();

            return Scaffold(
              backgroundColor: Color.fromRGBO(59, 169, 156, 1),
              appBar: AppBar(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Medication ',
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
                        'List of Medication',
                        style: GoogleFonts.lexend(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height - 220,
                        child: medicationCard(nextMedication: filteredData))
                  ])),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Add your action here
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => addMedicationV2(),
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
