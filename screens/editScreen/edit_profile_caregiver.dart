import 'package:cloud_firestore/cloud_firestore.dart';
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

class editProfileCaregiver extends StatefulWidget {
  editProfileCaregiver({super.key, required this.personal,});

  // variable of user input
  final personalInformationCaregiverClass personal;


  @override
  State<editProfileCaregiver> createState() => _editProfileState();
}

class _editProfileState extends State<editProfileCaregiver> {
  // create formkey
  final _formKey = GlobalKey<FormState>();

  // variable of user input
  // String? _enterFullName;
  // DateTime? _enterDOB;
  String? _email;
  String? _passsowrd;
  String? _role;
  String? _username;
  // String? _enterEmergency;

  void _editMedCloudFireStore(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    // save form
    _formKey.currentState!.save();

    try {
      //upload
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.personal.id)
          .update(
        {
          'id' : widget.personal.id,
          'email': _email,
          'password': _passsowrd,
          'role': 'caregiver',
          'username': _username,
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
  String? selectedGender;
  String? selectedMaritalStatus;
  TextEditingController? dateController;

  @override
  void initState() {
    super.initState();
    // Set the initial value to today's date
    // selectedDate = widget.personal.dateOfBirth;
    // _enterDOB = selectedDate;
    // selectedGender = widget.personal.gender;
    // selectedMaritalStatus = widget.personal.maritalStatus;
    // dateController = TextEditingController(
    //     text: DateFormat('yyyy-MM-dd').format(selectedDate!));
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate!,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       //save form
  //       _enterDOB = selectedDate;
  //       dateController!.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        backgroundColor: tiffany_blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkCyan, tiffany_blue],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height, // screen height
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 50, bottom: 50),
                  child: Text(
                    'Edit Personal Information',
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
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  width: double.infinity,
                  //height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 70,
                        ),
                        TextFormField(
                          initialValue: widget.personal.username,
                          decoration: const InputDecoration(
                              hintText: 'Username',
                              labelText: 'Username',
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
                            _username = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.personal.email,
                          decoration: const InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
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
                              return 'Please enter valid email address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _email = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.personal.password,
                          decoration: const InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
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
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _passsowrd = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
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
                                          12), // <-- Radius
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Back',
                                    style: GoogleFonts.lexend(
                                        fontSize: 18, color: hitam),
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                              height: 40,
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
                                    _editMedCloudFireStore(context);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: GoogleFonts.lexend(
                                      fontSize: 18,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    ));
  }
}
