import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/attendence_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/httpException.dart';
import 'package:intl/intl.dart';

class SingleEmpAttendence with ChangeNotifier {
  List<AttendenceCard> _attendenceList = [
    //  AttendenceCard(
    //       id: '2',
    //       name: 'Yuvan',
    //       checkInTime: '09:02:14',
    //       checkOutTime: '11:00:00'),
    //   AttendenceCard(
    //       id: '3',
    //       name: 'Salvin',
    //       checkInTime: '09:00:10',
    //       checkOutTime: '10:40:00'),
    //   AttendenceCard(
    //       id: '4',
    //       name: 'Karthik',
    //       checkInTime: '09:00:60',
    //       checkOutTime: '11:30:00')
  ];

  List<AttendenceCard> get attendenceList {
    return [..._attendenceList];
  }

  final _ip = 'http://192.168.1.101:94';
  Future<void> fetchAttendence(
      int empId, DateTime date1, DateTime date2) async {
    try {
      final url = Uri.parse(
          '$_ip/Overtime/GetEmployeeAttendance?empID=$empId&fromDate=${DateFormat('yyyy-MM-dd').format(date1)}&toDate=${DateFormat('yyyy-MM-dd').format(date2)}');
      final response = await http.get(url);
      //  print('inside');
      if (response.statusCode == 200) {
        final List<dynamic> loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        // print(loadedData);
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
