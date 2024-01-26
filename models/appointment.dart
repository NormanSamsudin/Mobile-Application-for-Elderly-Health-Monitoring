import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  const Appointment({
    this.id = '',
    required this.name,
    required this.place,
    required this.date,
    required this.accompany,
    required this.status,
  });
  final String id;
  final String name;
  final String place;
  final Timestamp date;
  final String accompany;
  final String status;
}
