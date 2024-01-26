import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seniorconnect/data/dummy_data.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/config/constants.dart';
import 'package:seniorconnect/config/input_decoration.dart';
// import 'package:seniorconnect/rubbish/image_med_input.dart';
import 'package:seniorconnect/models/medication.dart';

class editMedicationV2 extends StatefulWidget {
  editMedicationV2({super.key, required this.medication});
  final Medication medication;

  @override
  State<editMedicationV2> createState() => _editMedicationV2tate();
}

class _editMedicationV2tate extends State<editMedicationV2> {
  final _formKey = GlobalKey<FormState>();

  String? _medicationName;
  String? _medicationQuantity;
  TimeOfDay? _medicationStartTime;
  TimeOfDay? _medicationEndTime;

  void _addMedCloudFireStore(BuildContext context, String id) async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    print(_medicationName);
    print(_medicationQuantity);
    print(_medicationStartTime);
    print(_medicationEndTime);
    //print(_medicationStatus);

    try {
      // Handle Firestore update or upload logic here...
      await FirebaseFirestore.instance.collection('medication').doc(id).set({
        'id': id,
        'name': _medicationName,
        'quantity': _medicationQuantity,
        'startTime': DateTime(2023, 1, 1, _medicationStartTime!.hour,
            _medicationStartTime!.minute),
        'EndTime': DateTime(
            2023, 1, 1, _medicationEndTime!.hour, _medicationEndTime!.minute),
        'status': ''
      });

      Navigator.of(context).pop(); // Navigate back
    } on FirebaseFirestore catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  TextEditingController? timeStartController = TextEditingController();
  TextEditingController? timeEndController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeStartController!.text =
        DateFormat('h:mm a').format(widget.medication.startTime);
    timeEndController!.text =
        DateFormat('h:mm a').format(widget.medication.endTime);
  }

  Future<void> _selectStartDateTime(TimeOfDay? initialDateTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialDateTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _medicationStartTime = pickedTime; // Update the selected time
        timeStartController!.text = DateFormat('h:mm a').format(
          DateTime(2023, 1, 1, pickedTime.hour, pickedTime.minute),
        );
      });
    }
  }

  Future<void> _selectEndDateTime(TimeOfDay? initialDateTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialDateTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _medicationEndTime = pickedTime; // Update the selected time
        timeEndController!.text = DateFormat('h:mm a').format(
          DateTime(2023, 1, 1, pickedTime.hour, pickedTime.minute),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Madication'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/images/medicine_bg2.jpg'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter),
        ),
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, top: 50, bottom: 180),
                  child: Text(
                    '',
                    style: GoogleFonts.lexend(
                      color: putih,
                      fontSize: 23,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: putih,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  // width: double.infinity,
                  // height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 40),
                        child: Text(
                          'Edit Medication',
                          style: GoogleFonts.lexend(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              value: widget.medication.name,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Antidepresan',
                                  child: Text('Antidepresan'),
                                ),
                                DropdownMenuItem(
                                  value: 'Antiplatelet',
                                  child: Text('Antiplatelet'),
                                ),
                                DropdownMenuItem(
                                  value: 'Antihipertensi',
                                  child: Text('Antihipertensi'),
                                ),
                                DropdownMenuItem(
                                  value: 'Antidiabetik',
                                  child: Text('Antidiabetik'),
                                ),
                                DropdownMenuItem(
                                  value: 'Antiasid',
                                  child: Text('Antiasid'),
                                ),
                                DropdownMenuItem(
                                  value: 'Vitamin C',
                                  child: Text('Vitamin C'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _medicationName = value;
                                });
                              },
                              onSaved: (newValue) {
                                _medicationName = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Medicine Name',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.medical_services_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a place';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              controller: timeStartController,
                              readOnly: true,
                              onTap: () =>
                                  _selectStartDateTime(_medicationStartTime),
                              decoration: const InputDecoration(
                                labelText: 'Start Time',
                                hintText: 'Start Time',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.access_time,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              controller: timeEndController,
                              readOnly: true,
                              onTap: () =>
                                  _selectEndDateTime(_medicationEndTime),
                              decoration: const InputDecoration(
                                labelText: 'End Time',
                                hintText: 'End Time',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.access_time,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            DropdownButtonFormField<String>(
                              value: widget.medication.quantity,
                              items: const [
                                DropdownMenuItem(
                                  value: '1 Pill',
                                  child: Text('1 Pill'),
                                ),
                                DropdownMenuItem(
                                  value: '1.5 Pill',
                                  child: Text('1.5 Pill'),
                                ),
                                DropdownMenuItem(
                                  value: '2 Pill',
                                  child: Text('2 Pill'),
                                ),
                                DropdownMenuItem(
                                  value: '3 Pill',
                                  child: Text('3 Pill'),
                                ),
                                DropdownMenuItem(
                                  value: '1 Injection',
                                  child: Text('1 Injection'),
                                ),
                                DropdownMenuItem(
                                  value: '2 Injection',
                                  child: Text('2 Injection'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _medicationQuantity = value;
                                });
                              },
                              onSaved: (newValue) {
                                _medicationQuantity = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.place_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a Quantity';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: putih,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12),
                                        side: BorderSide(color: const Color.fromARGB(255, 100, 100, 100), width: 1.0) // <-- Radius
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Back',
                                        style: GoogleFonts.lexend(
                                            fontSize: 15, color: hitam),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                  height: 100,
                                ),
                                Container(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kepple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () {
                                        _addMedCloudFireStore(context, widget.medication.id);
                                      },
                                      child: Text(
                                        'Edit',
                                        style: GoogleFonts.lexend(
                                          fontSize: 15,
                                          color: Colors.white
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
