import 'package:flutter/cupertino.dart';

class AttendenceCard {
  final String id;
  final String name;
  final String checkInTime;
  final String checkOutTime;

  AttendenceCard(
      {required this.id,
      required this.name,
      required this.checkInTime,
      required this.checkOutTime});
}
