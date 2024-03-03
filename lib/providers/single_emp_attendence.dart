import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/attendence_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/httpException.dart';
import 'package:intl/intl.dart';
import './ip.dart';

class SingleEmpAttendence with ChangeNotifier {
  List<AttendenceCard> _attendenceList = [];

  List<AttendenceCard> get attendenceList {
    return [..._attendenceList];
  }

  Future<void> fetchAttendence(
      int empId, DateTime date1, DateTime date2) async {
    try {
      final url = Uri.parse(
          '$ip/Overtime/GetEmployeeAttendance?empID=$empId&fromDate=${DateFormat('yyyy-MM-dd').format(date1)}&toDate=${DateFormat('yyyy-MM-dd').format(date2)}');
      final response = await http.get(url);
      //  print('inside');
      if (response.statusCode == 200) {
        final List<dynamic> loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        // print(loadedData);
        // ignore: unnecessary_null_comparison
        if (loadedData == null) // || loadedData.length == 0)
        {
          throw HttpException('There is no records');
        }

        List<AttendenceCard> attendenceFetch = [];
        for (var emp in loadedData) {
          attendenceFetch.add(AttendenceCard(
              id: '',
              name: '',
              checkInTime: emp['IN_TIME'],
              checkOutTime: emp['OUT_TIME'],
              date: emp['D_DATE'],
              day: emp['D_DAY']));
        }
        // print(attendenceFetch);
        _attendenceList = attendenceFetch;
        notifyListeners();
      }
    } catch (error) {
      //print("exeption : " + error.toString());
      throw error;
    }
  }
}
