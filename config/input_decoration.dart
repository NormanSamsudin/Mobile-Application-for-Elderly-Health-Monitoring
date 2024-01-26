import 'package:flutter/material.dart';
import 'package:seniorconnect/config/colors.dart';

InputDecorationTheme theme = const InputDecorationTheme(
  // disabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(width: 1),
  // ),
  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 0, 0, 0)),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.green),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.black),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.red),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  filled: true,
  fillColor: Colors.white,
);

InputDecorationTheme theme2 = const InputDecorationTheme(
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Colors.black),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Color.fromARGB(184, 198, 131, 209)),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.white),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 3, color: Colors.red),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  filled: true,
  fillColor: Colors.white,
);
