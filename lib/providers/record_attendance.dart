import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordAttendance with ChangeNotifier {
  final _ip = 'http://192.168.1.101:94';
  Future<Map<String, dynamic>> recordAttendance(String payload) async {
    try {
      final url = Uri.parse('$_ip/Overtime/RecordAttendance?data=$payload');
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
