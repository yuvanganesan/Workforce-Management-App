import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/attendence_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/httpException.dart';
import 'package:intl/intl.dart';
import './ip.dart';

class AttendenceList with ChangeNotifier {
  List<AttendenceCard> _attendenceList = [];

  List<AttendenceCard> get attendenceList {
    return [..._attendenceList];
  }

  List<AttendenceCard> get presentList {
    _attendenceList
        .removeWhere((emp) => emp.checkInTime == 'A' || emp.checkInTime == 'H');
    return [..._attendenceList];
  }

  Future<void> fetchAttendence(DateTime date) async {
    try {
      final url = Uri.parse(
          '$ip/Overtime/getAttendance?data=${DateFormat('yyyy-MM-dd').format(date)}');
      final response = await http.get(url);
      //print('inside');
      if (response.statusCode == 200) {
        final List<dynamic> loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        //print(loadedData);
        if (loadedData.isEmpty) //|| loadedData.length == 0)
        {
          throw HttpException('There is no records');
        }

        List<AttendenceCard> attendenceFetch = [];
        loadedData.forEach((emp) {
          attendenceFetch.add(AttendenceCard(
              id: emp['EMP_ID'].toString(),
              name: emp['NAME'],
              checkInTime: emp['IN_TIME'],
              checkOutTime: emp['OUT_TIME'],
              date: '',
              day: ''));
        });
        //print(attendenceFetch);
        _attendenceList = attendenceFetch;
        notifyListeners();
      }
    } catch (error) {
      //print("exeption : " + error.toString());
      throw error;
    }
  }

  List<AttendenceCard> get latePunchList {
    List<AttendenceCard> _latePunchList = _attendenceList.where((emp) {
      final difference = DateTime.parse('2023-04-01T${emp.checkInTime}')
          .difference(DateTime.parse('2023-04-01T09:00:00'));
      //print(difference.inMinutes);
      //  print(difference.toString());
      if (difference.inMinutes > 0) {
        return true;
      }
      return false;
    }).toList();
    return [..._latePunchList];
  }

  List<AttendenceCard> get earlyPunchList {
    List<AttendenceCard> _earlyPunchList = _attendenceList.where((emp) {
      final difference = DateTime.parse('2023-04-01T11:00:00')
          .difference(DateTime.parse('2023-04-01T${emp.checkOutTime}'));
      // print(difference.toString());
      if (difference.inMinutes > 0) {
        return true;
      }
      return false;
    }).toList();
    return [..._earlyPunchList];
  }
}
