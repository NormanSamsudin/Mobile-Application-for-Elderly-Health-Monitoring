import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:seniorconnect/screens/editScreen/edit_profile_caregiver.dart';
import 'package:seniorconnect/screens/editScreen/edit_personal_information_elderly.dart';
import 'package:seniorconnect/widgets/infoWidget.dart';

class profileCaregiver extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _inputKey = '';
  void _addKeyElderly(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      // Handle Firestore update or upload logic here...
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'elderlyKey': _inputKey,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Key inserted'),
        ),
      );
      
    } on FirebaseFirestore catch (error) {
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
                  Text('No Personal Information Added'),
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
            //data retrieved
            var DocData = snapshot.data as DocumentSnapshot;

            Map<String, dynamic> data = DocData.data() as Map<String, dynamic>;

            bool keyExist = data.containsKey('elderlyKey');

            //Timestamp timestamp = DocData['dob'];
            //DateTime dateOfBirth = timestamp.toDate();
            return Scaffold(
              appBar: AppBar(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Caregiver Profile',
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 8, 88),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    )
                  ],
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              backgroundColor: Color.fromRGBO(59, 169, 156, 1),
              body: Container(
                  decoration: const BoxDecoration(
                  color: Color.fromRGBO(59, 169, 156, 1),
                
                ),
                child: ListView(
                  children: [
                    const Divider(
                      //color: Colors.black,
                      height: 25,
                      thickness: 0.75,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              'Personal Information',
                              style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white),
                            ),
                            Spacer(),
                            //Text('edit', style: TextStyle(color: Colors.white)),
                            // InkWell(
                            //   child: const Icon(
                            //     Icons.edit,
                            //     color: Colors.white,
                            //   ),
                            //   onTap: () {
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //         builder: (context) => editProfileCaregiver(
                            //             personal: personalInformationCaregiverClass(
                            //                 id: FirebaseAuth
                            //                     .instance.currentUser!.uid,
                            //                 role: 'caregiver',
                            //                 password: DocData['password'],
                            //                 email: DocData['email'],
                            //                 username: DocData['username']))));
                            //   },
                            // )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    infoWidget(label: 'Username', value: DocData['username']),
                    infoWidget(label: 'role', value: DocData['role']),
                    infoWidget(
                        label: 'Email Address', value: '${DocData['email']}'),
                    infoWidget(label: 'password', value: DocData['password']),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            keyExist
                                ? Text('Key is existed')
                                : Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Enter Key'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a key';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _inputKey = value!;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _addKeyElderly(context);
                                        },
                                        child: const Text('Submit', style: TextStyle(color: Colors.white),),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
