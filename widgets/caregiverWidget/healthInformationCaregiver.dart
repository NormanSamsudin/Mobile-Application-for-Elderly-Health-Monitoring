import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/models/healthInfo.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:seniorconnect/screens/editScreen/edit_health_information_elderly.dart';
import 'package:seniorconnect/widgets/tableRow.dart';

class healthInformationCaregiver extends StatelessWidget {
  healthInformationCaregiver(this.keys);

  final String keys;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(this.keys)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  Spacer(),
                  Text('User is not Exist'),
                  IconButton(
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => addAppointment(),
                        // ));
                      },
                      icon: Icon(Icons.abc)),
                  Spacer()
                ],
              ),
            );
          } else {
            var DocData = snapshot.data as DocumentSnapshot;

            Map<String, dynamic> data = DocData.data() as Map<String, dynamic>;

            // esok pagi sambung sini
            if (!data.containsKey('weight')) {
              print(data.keys);
              return Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                child: Container(
                  //color: Colors.white,
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: InkWell(
                      onTap: () {
                      
                      },
                      child: Center(
                        child: Text(
                          'No elderly health information available',
                          style: GoogleFonts.lexend(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      )),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                'Health Information',
                                style: GoogleFonts.lexend(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(42),
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth()
                        },
                        children: [
                          TableRow(children: [
                            tableRow('id'),
                            tableRow('Health Type'),
                            tableRow('Description'),
                          ]),
                          TableRow(children: [
                            tableRow('1'),
                            tableRow('Height (m)'),
                            tableRow(DocData['height']),
                          ]),
                          TableRow(children: [
                            tableRow('1'),
                            tableRow('Body Mass Index'),
                            tableRow((double.parse(DocData['weight']) /
                                    (double.parse(DocData['height']) *
                                        double.parse(DocData['height'])))
                                .toStringAsFixed(2)),
                          ]),
                          TableRow(children: [
                            tableRow('2'),
                            tableRow('Weight (kg)'),
                            tableRow(DocData['weight']),
                          ]),
                          TableRow(children: [
                            tableRow('3'),
                            tableRow('Blood Type'),
                            tableRow(DocData['bloodType']),
                          ]),
                          TableRow(children: [
                            tableRow('4'),
                            tableRow('Allergy'),
                            tableRow(DocData['allergies']),
                          ]),
                          TableRow(children: [
                            tableRow('5'),
                            tableRow('Vaccination'),
                            tableRow(DocData['covidVaccine']),
                          ]),
                          TableRow(children: [
                            tableRow('6'),
                            tableRow('Disease'),
                            tableRow(DocData['disease']),
                          ]),
                          TableRow(children: [
                            tableRow('7'),
                            tableRow('Marital Status'),
                            tableRow(DocData['maritalStatus']),
                          ]),
                          TableRow(children: [
                            tableRow('8'),
                            tableRow('Emergency Number'),
                            tableRow(DocData['emergency']),
                          ])
                        ],
                        border: TableBorder.all(
                          width: 1,
                          color: darkCyan,
                          style: BorderStyle.solid,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
