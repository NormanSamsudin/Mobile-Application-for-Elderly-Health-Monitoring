import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/config/constants.dart';
import 'package:seniorconnect/screens/authScreen/login_signup.dart';
import 'package:seniorconnect/screens/caregiverScreen/tabs.dart';
import 'package:seniorconnect/screens/elderlyScreen/tabs.dart';
import 'package:seniorconnect/screens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //textfieldtheme
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: const Color.fromARGB(255, 182, 237, 184),
          prefixIconColor: Colors.black,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide.none,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: kPrimaryColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
      ),
      // home: loginSignup(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting connection');
            return SplashScreen();
          }

          if (snapshot.hasData) {
            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }

                if (userSnapshot.hasData) {
                  DocumentSnapshot documentSnapshot = userSnapshot.data as DocumentSnapshot;
                  if (documentSnapshot.exists) {
                    if (documentSnapshot.get('role') == 'caregiver') {
                      return TabScreenCaregiver();
                    } else {
                      return TabScreenElderly();
                    }
                  } else {
                    return Center(
                      child: Text('Document does not exist in the database'),
                    );
                  }
                }

                return loginSignup();
              },
            );
          }

          // if (snapshot.hasData) {
          //   print('has data');
          //   //return TabScreenElderly();

          //   //User? user = FirebaseAuth.instance.currentUser;
          //   var kk = FirebaseFirestore.instance
          //       .collection('users')
          //       .doc(snapshot.data!.uid)
          //       .get()
          //       .then((DocumentSnapshot documentSnapshot) {
          //     if (documentSnapshot.exists) {
          //       if (documentSnapshot.get('role') == 'caregiver') {
          //         return TabScreenCaregiver();
          //       } else {
          //         return TabScreenElderly();
          //       }
          //     } else {
          //       return const Center(
          //         child: Center(
          //             child: Text('Document does not exist in the database')),
          //       );
          //     }
          //   });
          // }
          print('no data');
          return loginSignup();
        },
      ),
    );
  }
}
