import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/models/healthInfo.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:seniorconnect/screens/addScreen/add_personal_information_elderly.dart';
import 'package:seniorconnect/screens/editScreen/edit_health_information_elderly.dart';
import 'package:seniorconnect/screens/editScreen/edit_personal_information_elderly.dart';
import 'package:seniorconnect/widgets/tableRow.dart';
import 'package:intl/intl.dart';

class personalInformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
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
            if (!data.containsKey('fullName')) {
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => addPersonalInformationElderly(),
                        ));
                      },
                      child: Center(
                        child: Text(
                          'Insert Personal Information',
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

            Timestamp timestamp = DocData['dob'];
            DateTime dateOfBirth = timestamp.toDate();
            String dob = DateFormat('dd-MM-yyyy hh:mm a').format(dateOfBirth);

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
                                'Personal Information',
                                style: GoogleFonts.lexend(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              ),
                              const Spacer(),
                              const Text('edit',
                                  style: TextStyle(
                                      color: Color.fromARGB(160, 73, 73, 73))),
                              InkWell(
                                child: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(160, 73, 73, 73),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        editPersonalInformationElderly(
                                            personal: personalInformation(
                                                name: DocData['fullName'],
                                                dateOfBirth: dateOfBirth,
                                                gender: DocData['gender'],
                                                icNumber: DocData['ic'],
                                                address: DocData['address'],
                                                email: DocData['email'],
                                                maritalStatus: DocData['maritalStatus'],
                                                emergencyNumber: DocData['emergency'])),
                                  ));
                                },
                              )
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
                            tableRow('Information Type'),
                            tableRow('Description'),
                          ]),
                          TableRow(children: [
                            tableRow('1'),
                            tableRow('Name'),
                            tableRow(DocData['fullName']),
                          ]),
                          TableRow(children: [
                            tableRow('2'),
                            tableRow('Date of Birth'),
                            tableRow(dob),
                          ]),
                          TableRow(children: [
                            tableRow('3'),
                            tableRow('Gender'),
                            tableRow(DocData['gender']),
                          ]),
                          TableRow(children: [
                            tableRow('4'),
                            tableRow('Identification Number'),
                            tableRow(DocData['ic']),
                          ]),
                          TableRow(children: [
                            tableRow('6'),
                            tableRow('Home Address'),
                            tableRow(DocData['address']),
                          ]),
                          TableRow(children: [
                            tableRow('7'),
                            tableRow('Email Address'),
                            tableRow(DocData['email']),
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
                          ]),
                          TableRow(children: [
                            tableRow('9'),
                            tableRow('Elderly Key'),
                            tableRow(DocData['userid']),
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
