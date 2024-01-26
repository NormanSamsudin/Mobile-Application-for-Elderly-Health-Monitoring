import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  final String id;
  final String name;
  final String quantity;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  //final String imageUrl;

  const Medication({
    this.id = '',
    required this.name,
    required this.quantity,
    required this.startTime,
    required this.endTime,
    required this.status,
    //required this.imageUrl,
  });

  factory Medication.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Medication(
        name: data?['name'],
        quantity: data?['quantity'],
        startTime: data?['start_time'],
        endTime: data?['end_time'],
        status: data?['status'],
        //imageUrl: data?['image_url']
        );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (status != null) 'status': status,
      //if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}
