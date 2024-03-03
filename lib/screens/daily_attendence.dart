import 'package:flutter/material.dart';
import '../widgets/attendence_card_list.dart';

class Attendence extends StatelessWidget {
  static const routeName = '/attendence';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendence"),
      ),
      body: AttendenceCardList(),
    );
  }
}
