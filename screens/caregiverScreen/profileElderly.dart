import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:seniorconnect/screens/editScreen/edit_personal_information_elderly.dart';
import 'package:seniorconnect/widgets/caregiverWidget/healthInformationCaregiver.dart';
import 'package:seniorconnect/widgets/caregiverWidget/personalInformationCaregiver.dart';
import 'package:seniorconnect/widgets/infoWidget.dart';

class profileElderly extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Function to handle image selection and uploading
  Future<void> _pickAndUploadImage(BuildContext context, String id) async {
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
          String userId = id; //hardcoded

          // Update the Firestore document for the user
          await _firestore.collection('users').doc(userId).update({
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
    // TODO: implement build
    return StreamBuilder<Object>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid) //hardcoded
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              children: [
                Spacer(),
                Text('No Personal Information Added'),
                Spacer()
              ],
            ),
          );
        }

        var DocData = snapshot.data as DocumentSnapshot;

        Map<String, dynamic> key = DocData.data() as Map<String, dynamic>;

        if (!key.containsKey('elderlyKey')) {
          return Scaffold(
            appBar: AppBar(title: Text('Elderly Profile')),
            body: Container(
              color: Color.fromRGBO(59, 169, 156, 1),
              child: Center(child: Text('No elderly data available, please key elderly key first on your profile', style: TextStyle(color: Colors.white),)),
            ),
          );
        }

        return StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(DocData['elderlyKey'])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Column(
                    children: [
                      Spacer(),
                      Text('No Information Added'),
                      Spacer()
                    ],
                  ),
                );
              } else {
                //data retrieved
                var DocData2 = snapshot.data as DocumentSnapshot;
                Timestamp timestamp = DocData2['dob'];
                DateTime dateOfBirth = timestamp.toDate();
                var imageUrl = DocData2.get('image') as String;

                return Scaffold(
                  backgroundColor: Color.fromRGBO(59, 169, 156, 1),
                  appBar: AppBar(
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
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
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
                            !imageUrl.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 40, 15, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            imageUrl,
                                            width:
                                                120, // Set your width as needed
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
                                            // _pickAndUploadImage(context,
                                            //     DocData['id'].toString());
                                          },
                                          child: const Text(
                                            'Elderly Profile',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ))
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 40, 15, 0),
                                    child: InkWell(
                                      onTap: () {
                                        // Handle the tap.
                                        _pickAndUploadImage(
                                            context, DocData['id'].toString());
                                        print('Circle Icon Button Pressed!');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors
                                                  .blue, // Background color
                                              shape: BoxShape
                                                  .circle, // Make it circular
                                            ),
                                            padding: const EdgeInsets.all(
                                                20), // Padding to make the circle bigger
                                            child: const Icon(
                                              Icons
                                                  .touch_app, // The icon inside the circle
                                              color: Colors
                                                  .white, // Color of the icon
                                              size: 30, // Size of the icon
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Add Image',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
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
                        personalInformationCaregiver(DocData['elderlyKey']),
                        healthInformationCaregiver(DocData['elderlyKey']),
                      ],
                    ),
                  ),
                );
              }
            });
      },
    );
  }
}
