import 'package:seniorconnect/service/health_repository.dart';
import 'package:seniorconnect/models/healthData.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class HomeController {
  final repository = HealthRepository();
  final writeRepo = writeDataHealthRepository();
  final healthData = ValueNotifier(<HealthData>[]);
  
  Future<void> getData() async {
   healthData.value = await repository.getBloodPressureDiastolic();
    //await repository.getBloodPressureDiastolic();

  }

  Future<void> writeData(int heart_rate) async {
    await writeRepo.writeData(heart_rate);
  }
}
