import 'package:flutter/material.dart';
import '../models/login_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/httpException.dart';

class Authentication with ChangeNotifier {
  // ignore: prefer_final_fields
  LoginSession _employee =
      LoginSession(empId: "", name: "", designation: "", isStaff: false);
  bool _authStatus = false;

  bool get isAuth {
    return _authStatus;
  }

  void logout() {
    _authStatus = false;

    notifyListeners();
  }

  LoginSession get empDetail {
    return LoginSession(
        empId: _employee.empId,
        name: _employee.name,
        designation: _employee.designation,
        isStaff: _employee.isStaff);
  }

  final _ip = 'http://192.168.1.100:94';

  Future<void> login(String empId, String password) async {
    try {
      final url = Uri.parse(
          '$_ip/Overtime/ValidateEmployeeLogin?EMP_ID=$empId&PASS=$password');
      final response = await http.get(url);
      final _statusCode = json.decode(response.body)['statusCode'];
      // print(_statusCode);
      if (_statusCode == 200) {
        final Map<String, dynamic> loadedData =
            json.decode(response.body)['data'];

        LoginSession empDetailFetch = LoginSession(
            empId: loadedData["EMP_ID"].toString(),
            name: loadedData["NAME"],
            designation: loadedData["DESCRIPTION"],
            isStaff: loadedData["IS_STAFF"]);

        _employee = empDetailFetch;
        _authStatus = true;

        notifyListeners();
      } else {
        throw HttpException(json.decode(response.body)['statusMessage']);
      }
    } catch (error) {
      //print("exeption : " + error.toString());
      throw error;
    }
  }
}
