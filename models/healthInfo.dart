import 'package:flutter/material.dart';

class healthInformationElderly {
  const healthInformationElderly(
      {
      
      required this.height,
      required this.weight,
      required this.bloodType,
      required this.allergies,
      required this.covidVaccines,
      required this.chronicDisease,
});

  final double height;
  final double weight;
  final String bloodType;
  final String allergies;
  final String covidVaccines;
  final List<String> chronicDisease;
}
