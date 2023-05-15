import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/salary_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/httpException.dart';
import 'package:intl/intl.dart';

class OtDetail with ChangeNotifier {
  List<SalaryCard> _salaryCardList = [];

  List<SalaryCard> get salaryCardList {
    return [..._salaryCardList];
  }

  String get totalOtSalary {
    double total = 0;
    _salaryCardList.forEach((salCard) {
      total += double.parse(salCard.otSalary);
    });
    return total.round().toString();
  }

  final _ip = 'http://192.168.1.101:94';
  Future<void> fetchOtSalary(int empId, DateTime date1, DateTime date2) async {
    try {
      final url = Uri.parse(
          '$_ip/Overtime/GetOvertimeDetails?empID=$empId&fromDate=${DateFormat('yyyy-MM-dd').format(date1)}&toDate=${DateFormat('yyyy-MM-dd').format(date2)}');
      final response = await http.get(url);
      // print('inside $empId');
      if (response.statusCode == 200) {
        final List<dynamic> loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        // print(loadedData);
        if (loadedData == null) // || loadedData.length == 0)
        {
          throw HttpException('There is no records');
        }

        List<SalaryCard> salaryCardFetch = [];
        for (var emp in loadedData) {
          salaryCardFetch.add(SalaryCard(
              date: emp['SWIPE_DATE'],
              inTime: emp['IN_TIME'],
              outTime: emp['OUT_TIME'],
              workMins: emp['WORK_MINUTES'].toString(),
              workHours: emp['WORK_HOURS'].toString(),
              otSalary: emp['OT_SALARY'].round().toString()));
        }

        // print(salaryCardFetch);
        _salaryCardList = salaryCardFetch;
        notifyListeners();
      }
    } catch (error) {
      //print("exeption : " + error.toString());
      throw error;
    }
  }
}
