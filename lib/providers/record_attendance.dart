import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './ip.dart';

class RecordAttendance with ChangeNotifier {
  Future<Map<String, dynamic>> recordAttendance(String payload) async {
    try {
      final url = Uri.parse('$ip/Overtime/RecordAttendance?data=$payload');
      final response = await http.get(url);
      Map<String, dynamic> loadedData = {};
      if (response.statusCode == 200) {
        loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
      }
      return loadedData;
    } catch (error) {
      rethrow;
    }
  }
}
