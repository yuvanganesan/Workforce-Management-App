import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wagesui/widgets/ot_employees.dart';
import './employee.dart';
import 'dart:convert';
import '../models/httpException.dart';

class Employees with ChangeNotifier {
  List<Employee> _employees = [
    // Employee(
    //     id: '20bit02',
    //     name: 'Salvin',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit22',
    //     name: 'Karthi',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit29',
    //     name: 'Kavin ',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit67',
    //     name: 'Sam',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit75',
    //     name: 'Vignesh',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit62',
    //     name: 'Barathi',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit05',
    //     name: 'Sudharsan',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit72',
    //     name: 'Ragul',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit97',
    //     name: 'Dhanush',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0),
    // Employee(
    //     id: '20bit56',
    //     name: 'Ashok',
    //     imgUrl:
    //         'https://thumbs.dreamstime.com/z/skilled-young-professional-looking-camera-posing-office-team-colleagues-background-successful-startup-founder-corporate-116972904.jpg',
    //     statusCode: 0)
  ];
  final _ip = 'http://192.168.1.100:94';
  Future<void> fetchEmployee() async {
    try {
      final url = Uri.parse('$_ip/Overtime/GetOvertimeEmployees');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];
        //print(loadedData);
        if (loadedData == null) {
          throw HttpException('There is no Employee');
        }
        List<Employee> employeeFetch = [];
        loadedData.forEach((emp) {
          employeeFetch.add(Employee(
              empId: emp['EMP_ID'].toString(),
              id: emp['ID'].toString(),
              name: emp['NAME'],
              imgUrl: emp['IMAGE_URL'],
              statusCode: emp['STATUS'],
              isModified: false));
        });
        _employees = employeeFetch;
        _setOtEmployees();
      }
    } catch (error) {
      // print("exeption : " + error.toString());
      throw error;
    }
  }

  List<Employee> get allEmployees {
    return [..._employees];
  }

  List<Employee> _otEmployees = [];

  void _setOtEmployees() {
    _otEmployees = _employees.where(
      (emp) {
        return (emp.statusCode == 1 || emp.statusCode == 5);
      },
    ).toList();
  }

  List<Employee> get otEmployees {
    return [..._otEmployees];
  }

  Future<void> addOtEmployee() async {
    try {
      final url = Uri.parse('$_ip/Overtime/InsertUpdateOvertime');

      _otEmployees = _employees.where(
        (emp) {
          if (emp.todayOt == true) {
            emp.statusCode = 1;
          } else {
            emp.statusCode = 0;
          }

          return emp.todayOt == true;
        },
      ).toList();

      List<Map> data = List.generate(_employees.length, (index) {
        return {
          "EMP_ID": int.parse(_employees[index].empId),
          "ID": int.parse(_employees[index].id),
          "STATUS": _employees[index].statusCode
        };
      });

      final response = await http.post(
        url, body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },

        // headers: {
        //   'Content-type': 'application/json; charset=UTF-8',
        //   // 'Accept': '*/*',
        //}
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> otConfirm() async {
    try {
      final url = Uri.parse('$_ip/Overtime/InsertUpdateOvertime');
      _otEmployees.forEach((otEmp) {
        otEmp.statusCode = 5;
      });

      List<Map> data = List.generate(_otEmployees.length, (index) {
        return {
          "EMP_ID": int.parse(_otEmployees[index].empId),
          "ID": int.parse(_otEmployees[index].id),
          "STATUS": _otEmployees[index].statusCode
        };
      });

      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }
}
