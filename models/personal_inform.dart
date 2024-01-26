import 'package:flutter/material.dart';

class personalInformation {
  const personalInformation(
      {
      required this.name,
      required this.dateOfBirth,
      required this.gender,
      required this.icNumber,
      required this.address,
      required this.email,
      required this.maritalStatus,
      required this.emergencyNumber});


  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final String icNumber;
  final String address;
  final String email;
  final String maritalStatus;
  final String emergencyNumber;
}

class personalInformationCaregiverClass {
  const personalInformationCaregiverClass(
      {this.id = '',
      required this.role,
      required this.password,
      required this.email,
      required this.username});
  final String id;
  final String email;
  final String password;
  final String role;
  final String username;
}
