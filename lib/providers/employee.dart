import 'package:flutter/material.dart';

class Employee with ChangeNotifier {
  final String empId;
  final String id;
  final String name;
  final String imgUrl;
  int statusCode;
  bool isModified = false;
  bool todayOt = false;

  Employee(
      {required this.empId,
      required this.id,
      required this.name,
      required this.imgUrl,
      required this.statusCode,
      required this.isModified});

  void setTodayOt(bool value) {
    this.isModified = true;

    this.todayOt = value;
    notifyListeners();
  }
}
