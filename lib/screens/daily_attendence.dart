import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/attendence_card_list.dart';
import '../providers/attendenceList.dart';

class Attendence extends StatelessWidget {
  static const routeName = '/attendence';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendence"),
        ),
        body: ChangeNotifierProvider.value(
          value: AttendenceList(),
          child: AttendenceCardList(),
        ));
  }
}
