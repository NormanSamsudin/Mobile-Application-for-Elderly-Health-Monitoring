import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataStream {
  //create stream controller
  final StreamController<Map<String, dynamic>> _dataController =
      StreamController<Map<String, dynamic>>();

  // getter function to stream
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;

  // method to fetch data
  void fetchDataFromFirebase() async {
    
    try {
      final url = Uri.https(
          'seniorconnect-f67ed-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/healthData.json');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response ${response.statusCode}');
        final jsonData = jsonDecode(response.body);

        // kalau data tu wujud
        if (jsonData != null) {

          print('data wujud');
          print('jsonData type: ${jsonData.runtimeType}');
          _dataController.add(jsonData);
          print('data added');
        }
        // kaau xde data
        else {
          print('ada error');
          _dataController.addError('No data available');
        }
      } else {
        print('ada error');
        _dataController.addError('failed to fetch data');
      }
    } catch (e) {
      _dataController.addError(' Error: $e');
    }
  }

  void dispose() {
    _dataController.close();
  }
}
