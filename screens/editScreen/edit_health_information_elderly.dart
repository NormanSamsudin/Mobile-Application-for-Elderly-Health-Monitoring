import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorconnect/models/healthInfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/config/constants.dart';

class editHealthInformationElderly extends StatefulWidget {
  editHealthInformationElderly({
    super.key,
    required this.personal,
  });

  // variable of user input
  final healthInformationElderly personal;

  @override
  State<editHealthInformationElderly> createState() => _editProfileState();
}

class _editProfileState extends State<editHealthInformationElderly> {
  // create formkey
  final _formKey = GlobalKey<FormState>();

  // variable of user input
  double? _enterHeight;
  double? _enterWeight;
  String? _enterBloodType;
  String? _enterAllergies;
  String? _enterCovidVacination;
  String? _enterChronicDisease;

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
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          'height': _enterHeight.toString(),
          'weight': _enterWeight.toString(),
          'bloodType': _enterBloodType,
          'allergies': _enterAllergies,
          'covidVaccine': _enterCovidVacination,
          'disease': _enterChronicDisease,
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

  String? selectedGender;
  String? selectedMaritalStatus;

  @override
  void initState() {
    super.initState();
    // Set the initial value to today's date
    //selectedGender = widget.personal.gender;
    //selectedMaritalStatus = widget.personal.maritalStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Information'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'lib/assets/images/healthdata_bg.jpg',
              ),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter),
        ),
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height, // screen height
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, top: 50, bottom: 150),
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
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 40),
                        child: Text(
                          'Edit Health Information',
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
                              initialValue: widget.personal.height.toString(),
                              decoration: const InputDecoration(
                                  hintText: 'Height(m)',
                                  labelText: 'Height(m)',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(
                                      Icons.numbers_rounded,
                                    ),
                                  )),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty || double.parse(value) > 10) {
                                  return 'Please enter valid height';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enterHeight = double.parse(newValue!)!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              initialValue: widget.personal.weight.toString(),
                              decoration: const InputDecoration(
                                  hintText: 'Weight',
                                  labelText: 'Weight',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Icon(
                                      Icons.numbers_rounded,
                                    ),
                                  )),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter valid weight';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enterWeight = double.parse(newValue!)!;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: 'A+',
                              items: const [
                                DropdownMenuItem(
                                  value: 'A+',
                                  child: Text('A+'),
                                ),
                                DropdownMenuItem(
                                  value: 'A-',
                                  child: Text('A-'),
                                ),
                                DropdownMenuItem(
                                  value: 'B+',
                                  child: Text('B+'),
                                ),
                                DropdownMenuItem(
                                  value: 'B-',
                                  child: Text('B-'),
                                ),
                                DropdownMenuItem(
                                  value: 'AB+',
                                  child: Text('AB+'),
                                ),
                                DropdownMenuItem(
                                  value: 'AB-',
                                  child: Text('AB-'),
                                ),
                                DropdownMenuItem(
                                  value: 'O+',
                                  child: Text('O+'),
                                ),
                                DropdownMenuItem(
                                  value: 'O-',
                                  child: Text('O-'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _enterBloodType = value;
                                });
                              },
                              onSaved: (newValue) {
                                _enterBloodType = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Blood Type',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.abc_rounded,
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
                            DropdownButtonFormField<String>(
                              value: 'None',
                              items: const [
                                DropdownMenuItem(
                                  value: 'None',
                                  child: Text('None'),
                                ),
                                DropdownMenuItem(
                                  value: 'Food: Soy',
                                  child: Text('Food: Soy'),
                                ),
                                DropdownMenuItem(
                                  value: 'Food: Seafood',
                                  child: Text('Food: Seafood'),
                                ),
                                DropdownMenuItem(
                                  value: 'Food: Eggs',
                                  child: Text('Food: Eggs'),
                                ),
                                DropdownMenuItem(
                                  value: 'Food: Milk',
                                  child: Text('Food: Milk'),
                                ),
                                DropdownMenuItem(
                                  value: 'Drug: Penicillin',
                                  child: Text('Drug: Penicillin'),
                                ),
                                DropdownMenuItem(
                                  value: 'Drug: Antibiotics',
                                  child: Text('Drug: Antibiotics'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _enterAllergies = value;
                                });
                              },
                              onSaved: (newValue) {
                                _enterAllergies = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Allergies',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.cancel,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your allergy';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: 'Pfizer-BioNTech',
                              items: const [
                                DropdownMenuItem(
                                  value: 'None',
                                  child: Text('None'),
                                ),
                                DropdownMenuItem(
                                  value: 'Pfizer-BioNTech',
                                  child: Text('Pfizer-BioNTech'),
                                ),
                                DropdownMenuItem(
                                  value: 'Moderna',
                                  child: Text('Moderna'),
                                ),
                                DropdownMenuItem(
                                  value: 'Oxford-AstraZeneca',
                                  child: Text('Oxford-AstraZeneca'),
                                ),
                                DropdownMenuItem(
                                  value: 'Sinovac-CoronaVac',
                                  child: Text('Sinovac-CoronaVac'),
                                ),
                                DropdownMenuItem(
                                  value: 'Sputnik V',
                                  child: Text('Sputnik V'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _enterCovidVacination = value;
                                });
                              },
                              onSaved: (newValue) {
                                _enterCovidVacination = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Covid Vaccine',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.vaccines_sharp,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a covid vaccine';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: 'Negative',
                              items: const [
                                DropdownMenuItem(
                                  value: 'Negative',
                                  child: Text('Negative'),
                                ),
                                DropdownMenuItem(
                                  value: 'Positive',
                                  child: Text('Positive'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _enterChronicDisease = value;
                                });
                              },
                              onSaved: (newValue) {
                                _enterChronicDisease = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Covid Status',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.sick_sharp,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a covid status';
                                }
                                return null;
                              },
                            ),
                            // TextFormField(
                            //   initialValue: widget.personal.chronicDisease.first.toString(),
                            //   decoration: const InputDecoration(
                            //       hintText: 'Covid Status',
                            //       labelText: 'Covid Status',
                            //       prefixIcon: Padding(
                            //         padding: EdgeInsets.all(defaultPadding),
                            //         child: Icon(
                            //           Icons.sick_sharp,
                            //         ),
                            //       )),
                            //   keyboardType: TextInputType.number,
                            //   autocorrect: false,
                            //   textCapitalization: TextCapitalization.none,
                            //   validator: (value) {
                            //     if (value == null || value.trim().isEmpty) {
                            //       return 'Please select covid status';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (newValue) {
                            //     _enterChronicDisease = newValue!;
                            //   },
                            // ),
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
                                  height: 80,
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
                                        'Add',
                                        style: GoogleFonts.lexend(
                                            fontSize: 15, color: Colors.white),
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
