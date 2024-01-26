import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:io'; //File
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/config/constants.dart';
import 'package:seniorconnect/config/input_decoration.dart';
// import 'package:seniorconnect/rubbish/image_med_input.dart';
import 'package:seniorconnect/models/medication.dart';

class addPersonalInformationElderly extends StatefulWidget {
  @override
  State<addPersonalInformationElderly> createState() => _editProfileState();
}

class _editProfileState extends State<addPersonalInformationElderly> {
  // create formkey
  final _formKey = GlobalKey<FormState>();

  // variable of user input
  String? _enterFullName;
  DateTime? _enterDOB;
  String? _enterGender;
  String? _enterIC;
  String? _enterAddress;
  String? _enterMaritalStatus;
  String? _enterEmergency;

  void _addProfileCloudFireStore(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    // save form
    _formKey.currentState!.save();

    print(_enterFullName);
    print(_enterDOB);
    print(_enterGender);
    print(_enterIC);
    print(_enterAddress);
    print(_enterMaritalStatus);
    print(_enterEmergency);

    try {
      //upload
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          // 'id': widget.personal.id,
          'fullName': _enterFullName,
          'dob': _enterDOB,
          'gender': _enterGender.toString(),
          'ic': _enterIC.toString(),
          'address': _enterAddress,
          'maritalStatus': _enterMaritalStatus,
          'emergency': _enterEmergency,
        },
      );

      // balik ke page asal
      Navigator.of(context).pop();
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

  DateTime? selectedDate;
  TextEditingController? dateController = TextEditingController();
  TextEditingController? timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDateTime(DateTime? initialDateTime) async {
    //mula2 pick tarikh dlu
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // baru pilih masa
    if (picked != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _enterDOB = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          //nak format data
          dateController!.text = DateFormat('yyyy-MM-dd').format(_enterDOB!);
          timeController!.text = DateFormat('HH:mm').format(_enterDOB!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elderly Information'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'lib/assets/images/personaldata_bg2.jpg',
              ),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, top: 50, bottom: 100),
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
                          topRight: Radius.circular(40))),
                  width: double.infinity,
                  //height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 40),
                        child: Text(
                          'Add Personal Information',
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
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Full Name',
                                  labelText: 'Full Name',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(
                                      Icons.abc_sharp,
                                    ),
                                  )),
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a valid full name';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enterFullName = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () => _selectDateTime(
                                  _enterDOB), // Open date picker on tap
                              decoration: const InputDecoration(
                                  labelText: 'Date of Birth',
                                  hintText: 'Date of Birth',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(
                                      Icons.inventory_sharp,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: 'Male',
                              items: const [
                                DropdownMenuItem(
                                  value: 'Male',
                                  child: Text('Male'),
                                ),
                                DropdownMenuItem(
                                  value: 'Female',
                                  child: Text('Female'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _enterGender = value;
                                });
                              },
                              onSaved: (newValue) {
                                _enterGender = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.male_rounded,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a gender';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Identical Card Number',
                                  labelText: 'Identical Card Number',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(
                                      Icons.edit_document,
                                    ),
                                  )),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter valid IC Number';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enterIC = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Address',
                                  labelText: 'Address',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(
                                      Icons.location_on,
                                    ),
                                  )),
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a valid address';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enterAddress = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: 'Single',
                              items: const [
                                DropdownMenuItem(
                                  value: 'Single',
                                  child: Text('Single'),
                                ),
                                DropdownMenuItem(
                                  value: 'Married',
                                  child: Text('Married'),
                                ),
                                DropdownMenuItem(
                                  value: 'Divorced',
                                  child: Text('Divorced'),
                                ),
                                DropdownMenuItem(
                                  value: 'Widowed',
                                  child: Text('Widowed'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _enterMaritalStatus = value;
                                });
                              },
                              onSaved: (newValue) {
                                _enterMaritalStatus = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Marital Status',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.accessibility_new_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select marital status';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Emergency Contact',
                                  labelText: 'Emergency Contact',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(
                                      Icons.inventory_sharp,
                                    ),
                                  )),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please insert valid emergency contact';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enterEmergency = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 30,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: const BorderSide(
                                                color:  Color.fromARGB(
                                                    255, 100, 100, 100),
                                                width: 1.0) // <-- Radius
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
                                  height: 20,
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
                                        _addProfileCloudFireStore(context);
                                      },
                                      child: Text(
                                        'Add',
                                        style: GoogleFonts.lexend(
                                            fontSize: 15, color: Colors.white),
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
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
