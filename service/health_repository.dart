import 'package:seniorconnect/models/healthData.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class HealthRepository {
  final health = HealthFactory();


  
  Future<List<HealthData>> getBloodPressureDiastolic() async {
    // nak request access utk authorize
    bool requested = await health.requestAuthorization([
      HealthDataType.BLOOD_GLUCOSE,
      // HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BODY_TEMPERATURE,
    ]);

    if (requested) {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          DateTime.now().subtract(const Duration(days: 7)), DateTime.now(), [
        HealthDataType.BLOOD_GLUCOSE,
        // HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.BODY_TEMPERATURE,
      ]);

      return healthData.map((e) => HealthData(
        type: e.typeString,
        value:  double.parse(e.value.toString()),
        unit: e.unit.toString(),
        dateFrom: e.dateFrom,
        dateTo: e.dateTo)).toList();
    }
    return [];
  }
}

class writeDataHealthRepository {
  // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
  final health = HealthFactory();
  Future<void> writeData(int heart_rate) async {
    // define the types to get
    var types = [HealthDataType.HEART_RATE, HealthDataType.SLEEP_SESSION];

    var permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
    ];

    await health.requestAuthorization(types, permissions: permissions);



    print('------------------------------------------------------------------');

    // write steps and blood glucose
    bool success = await health.writeHealthData(
      heart_rate.toDouble(),
      HealthDataType.HEART_RATE,
      DateTime.now(),
      DateTime.now().add(const Duration(seconds: 10)));

    print('Result : $success');

    // success = await health.writeHealthData(25, HealthDataType.STEPS, now, now);
    // print('step : $success');

    // success = await health.writeWorkoutData(
    //     HealthWorkoutActivityType.RUNNING,
    //     DateTime.now(),
    //     DateTime.now(),
    //     totalDistance: 120,
    //     totalDistanceUnit: HealthDataUnit.METER,
    //     totalEnergyBurned: 10,
    //     totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE);
    print('------------------------------------------------------------------');
  }
}

/*
    // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
    final health = HealthFactory(useHealthConnectIfAvailable: true);

    // define the types to get
    var types = [
      HealthDataType.STEPS,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_SESSION,
      HealthDataType.WORKOUT
    ];

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(Duration(days: 1)), now, types);

    // request permissions to write steps and blood glucose
    types = [HealthDataType.STEPS, HealthDataType.BLOOD_GLUCOSE];
    var permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE
    ];
    await health.requestAuthorization(types, permissions: permissions);

    // write steps and blood glucose
    bool success =
        await health.writeHealthData(10, HealthDataType.STEPS, now, now);
    success = await health.writeHealthData(
        3.1, HealthDataType.BLOOD_GLUCOSE, now, now);

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    print('steps $steps');
    print(healthData);
*/
