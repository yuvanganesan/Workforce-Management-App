import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Ratings {
  final String empId;
  final String name;
  double ratingStar;
  String stageId;
  final String id;
  final date;

  bool isModified = false;

  Ratings(
      {required this.empId,
      required this.name,
      required this.ratingStar,
      required this.stageId,
      required this.id,
      required this.date});
}
