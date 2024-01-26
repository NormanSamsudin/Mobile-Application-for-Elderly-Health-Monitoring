import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seniorconnect/firebase_options.dart';
import 'package:seniorconnect/screens/my_app.dart';
void main() async {
  // kalau ak pakai firestore only
  WidgetsFlutterBinding.ensureInitialized();
  //initial setup for untuk guna firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


