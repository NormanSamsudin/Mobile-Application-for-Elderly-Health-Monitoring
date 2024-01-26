
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/models/medication.dart';

import 'package:seniorconnect/screens/addScreen/add_medication.dart';
import 'package:seniorconnect/widgets/caregiverWidget/medicationCard.dart';
import 'package:seniorconnect/widgets/elderlyWidget/medicationCard.dart';



class medicationElderly extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: AppBar(title: const Text('Medication',), backgroundColor: tiffany_blue,),
      body: StreamBuilder(
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
              return  Center(
                child: Column(
                  children: [
                    Spacer(),
                    Text('No Medication Added'),
                    IconButton(
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => addMedicationV2(),
                          // ));
                        },
                        icon: Icon(Icons.abc)),
                        Spacer()
                  ],
                ),
              );
            } else {
    
              List<Medication> listMedic = [];
              print(snapshot.data);
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
                status: med['status']
              ));
            }

            var filteredData = listMedic.where((item) => item.status == '').toList();

            return Scaffold(
             backgroundColor: Color.fromRGBO(59, 169, 156, 1),
              appBar: AppBar(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text('Medication', style: TextStyle(color: Color.fromARGB(255, 76, 8, 88), ),),
                     SizedBox(width: 40,)
                  ],
                ),
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
              ),

              body:MedicationCard(medications: filteredData),
 
            );
            }
          }),
    );
  }
}
