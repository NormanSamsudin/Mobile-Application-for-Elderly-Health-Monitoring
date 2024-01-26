import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/models/healthInfo.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:seniorconnect/screens/editScreen/edit_personal_information_elderly.dart';
import 'package:seniorconnect/widgets/elderlyWidget/chronicDisease.dart';
import 'package:seniorconnect/widgets/elderlyWidget/healthInformationElderly.dart';
import 'package:seniorconnect/widgets/elderlyWidget/multiSelectWidget.dart';
import 'package:seniorconnect/widgets/elderlyWidget/personalInformationElderly.dart';

import 'package:seniorconnect/widgets/infoWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seniorconnect/widgets/tableRow.dart';

class profileElderly extends StatefulWidget {
  @override
  State<profileElderly> createState() => _profileElderlyState();
}

class _profileElderlyState extends State<profileElderly> {
  final ImagePicker _picker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Function to handle image selection and uploading
  Future<void> _pickAndUploadImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
      imageQuality: 50, // Reduces the image size for quicker uploads
    );

    if (image != null) {
      File file = File(image.path);
      try {
        // Upload to Firebase Storage
        String fileName = file.path;
        Reference ref = _storage.ref().child('users/$fileName');
        UploadTask uploadTask = ref.putFile(file);

        // Get URL to the uploaded file
        await uploadTask.whenComplete(() async {
          String downloadUrl = await ref.getDownloadURL();

          // Get the current user's ID
          //String userId = 'QflfE4FEGtXQhOtw2j9OEnY8omI3'; //hardcoded

          // Update the Firestore document for the user
          await _firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'image': downloadUrl,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully!')),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during image upload: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

            //List<String> _selectedItems = DocData['chronic'];

            //var imageUrl = DocData.get('image') as String;

            return Scaffold(
              backgroundColor: Color.fromRGBO(59, 169, 156, 1),
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Elderly Profile',
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 8, 88),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    )
                  ],
                ),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(59, 169, 156, 1),
                ),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        !data.containsKey('image')
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(40, 40, 15, 0),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 60,
                                      backgroundImage: AssetImage(
                                          'lib/assets/images/profile.png'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _pickAndUploadImage(context);
                                      },
                                      child: const Text(
                                        'Add Image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 40, 15, 0),
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        DocData.get('image') as String,
                                        width: 120, // Set your width as needed
                                        height:
                                            120, // Set your height as needed
                                        fit: BoxFit
                                            .cover, // Use BoxFit to cover to ensure the image fills the circle
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _pickAndUploadImage(context);
                                      },
                                      child: const Text(
                                        'Update Image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                )),
                      ],
                    ),
                    const Divider(
                      //color: Colors.black,
                      height: 25,
                      thickness: 0.75,
                      indent: 20,
                      endIndent: 20,
                    ),
                    personalInformationWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    healthInformation(),
                    const SizedBox(
                      height: 10,
                    ),
                    chronicDiseaseElderly(snapshots: DocData),
                  ],
                ),
              ),
            );
          }
        });
  }
}
