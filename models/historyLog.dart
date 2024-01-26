import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class logHistory {
  //constructor
  const logHistory({
    this.id = '',
    required this.name,
    required this.status,
    required this.time,
  });

  
  final String id;
  final String name;
  final DateTime time;
  final String status;
}
