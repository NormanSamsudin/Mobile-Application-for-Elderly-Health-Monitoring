
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seniorconnect/models/appointment.dart';
import 'package:seniorconnect/models/healthData.dart';
import 'package:seniorconnect/models/medication.dart';

import 'package:flutter/material.dart'; // Import TimeOfDay

class medication {
  const medication({
    required this.name,
    required this.quantity,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.imageUrl,
  });
  final String name;
  final double quantity;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String status;
  final String imageUrl;
}


  List<HealthData> heart_rate_dummy = [

     HealthData(
        type: 'HEART_RATE',
        value: 40,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

     HealthData(
        type: 'HEART_RATE',
        value: 68,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 1, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

      HealthData(
        type: 'HEART_RATE',
        value: 75,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,2, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

      HealthData(
        type: 'HEART_RATE',
        value: 70,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,3, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

      HealthData(
        type: 'HEART_RATE',
        value: 69,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,4, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

      HealthData(
        type: 'HEART_RATE',
        value: 68,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 5, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

      HealthData(
        type: 'HEART_RATE',
        value: 70,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,6, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

      HealthData(
        type: 'HEART_RATE',
        value: 74,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,7, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),
      
      HealthData(
        type: 'HEART_RATE',
        value: 70,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,8, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),
      
      HealthData(
        type: 'HEART_RATE',
        value: 74,
        unit: '',
        dateFrom: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,9, 0),
        dateTo: DateTime.now().subtract(Duration(seconds: 5))),

  ];

//  final List<Medication> dummyMedications = [
//     Medication(
//       name: "Ubat Sakit jantung",
//       quantity: 1.5,
//       startTime: DateTime.now().add(Duration(hours: 8, minutes: 0)),
//       endTime: DateTime.now().add(Duration(hours: 9, minutes: 0)),
//       status: "Taken",
//       // imageUrl: "https://rootofscience.com/blog/wp-content/uploads/2023/03/ubat-gliclazide.jpg",
//     ),
//     Medication(
//       name: "Ubat Saraf",
//       quantity: 0.5,
//       startTime: DateTime.now().add(Duration(hours: 10, minutes: 30)),
//       endTime: DateTime.now().add(Duration(hours: 11, minutes: 30)),
//       status: "Taken",
//       // imageUrl: "https://rootofscience.com/blog/wp-content/uploads/2023/03/ubat-gliclazide.jpg",
//     ),
//     Medication(
//       name: "Ubat Kencing Manis",
//       quantity: 2.0,
//       startTime: DateTime.now().add(Duration(hours: 12, minutes: 0)),
//       endTime: DateTime.now().add(Duration(hours: 13, minutes: 0)),
//       status: "Taken",
//       // imageUrl: "https://rootofscience.com/blog/wp-content/uploads/2023/03/ubat-gliclazide.jpg",
//     ),
//     Medication(
//       name: "Ubat Darah Tinggi",
//       quantity: 0.75,
//       startTime: DateTime.now().add(Duration(hours: 14, minutes: 0)),
//       endTime: DateTime.now().add(Duration(hours: 15, minutes: 0)),
//       status: "Untaken",
//       // imageUrl: "https://rootofscience.com/blog/wp-content/uploads/2023/03/ubat-gliclazide.jpg",
//     ),
//     Medication(
//       name: "Ubat Kencing Manis",
//       quantity: 1.0,
//       startTime: DateTime.now().add(Duration(hours: 16, minutes: 0)),
//       endTime: DateTime.now().add(Duration(hours: 17, minutes: 0)),
//       status: "Untaken",
//       // imageUrl: "https://rootofscience.com/blog/wp-content/uploads/2023/03/ubat-gliclazide.jpg",
//     ),
//   ];


List<Appointment> dummyAppointments = [
  Appointment(
    id: '4',
    name: 'Diebetes Operation',
    place: 'Hospital Kuala Lumpur', // Replace with the actual place value
    date: Timestamp.fromDate(DateTime(2023, 10, 20, 9, 30)), // Replace with the actual date and time
    accompany: 'Norman',

    status: 'Absent'
  ),
  Appointment(
    id: '5',
    name: 'Ultrasound Test',
    place: 'Hospital Selayang', // Replace with the actual place value
    date: Timestamp.fromDate(DateTime(2023, 10, 22, 13, 45)), // Replace with the actual date and time
        accompany: 'Norman',
   
    status: 'Absent'
  ),
  Appointment(
    id: '6',
    name: 'Medical Checkup',
    place: 'Hospital Serdang', // Replace with the actual place value
    date: Timestamp.fromDate(DateTime(2023, 10, 25, 12, 0)), // Replace with the actual date and time
        accompany: 'Norman',
    
    status: 'Absent'
  ),
  Appointment(
    id: '7',
    name: 'Hemodialisis',
    place: 'Hospital Putrajaya', // Replace with the actual place value
    date: Timestamp.fromDate(DateTime(2023, 10, 25, 12, 0)), // Replace with the actual date and time
        accompany: 'Norman',

    status: 'Absent'
  ),
  Appointment(
    id: '8',
    name: 'Check Up Jantung',
    place: 'Institut Jantung Negara', // Replace with the actual place value
    date: Timestamp.fromDate(DateTime(2023, 11, 1, 8, 0)), // Replace with the actual date and time
        accompany: 'Norman',

    status: 'Absent'
  ),
];

// hospital besar kuala lumpur
// https://photos.wikimapia.org/p/00/01/52/72/21_big.jpg

// hospital selayang
// https://www.ssyenc.co.kr/file/record/304/%EA%B1%B4%EC%B6%95_%EB%B3%91%EC%9B%90_%EC%85%80%EB%9D%BC%EC%96%91%EB%B3%91%EC%9B%90_1998.09_01(0).jpg

// hospital serdang
// https://assets.bharian.com.my/images/articles/Hospital_Serdang_-_30j_1627615031.jpg

// hospital putrajaya
// https://www.utusan.com.my/wp-content/uploads/UTU_HOSPITAL9797-2048x1158.jpg

// Institute jantung negara
// https://clinicalresearch.my/wp-content/uploads/2021/01/National-Heart-Institute.jpg