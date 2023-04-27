import 'package:flutter/material.dart';
import '../models/attendence_card.dart';
import 'package:provider/provider.dart';
import '../providers/attendenceList.dart';

class LatePunch extends StatelessWidget {
  final _index;
  LatePunch(this._index);
  @override
  Widget build(BuildContext context) {
    List<AttendenceCard> lateEarlyPunchList = _index == 0
        ? Provider.of<AttendenceList>(context, listen: false).latePunchList
        : Provider.of<AttendenceList>(context, listen: false).earlyPunchList;
    return lateEarlyPunchList.isNotEmpty
        ? ListView.builder(
            itemCount: lateEarlyPunchList.length,
            itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        child: Text(
                          lateEarlyPunchList[index].id,
                          style: TextStyle(color: Colors.white),
                        )),
                    title: Text(lateEarlyPunchList[index].name),
                    subtitle: _index == 0
                        ? Text(
                            'Late by : ${(DateTime.parse('2023-04-01T${lateEarlyPunchList[index].checkInTime}').difference(DateTime.parse('2023-04-01T09:00:00'))).toString().substring(0, 7)} In time : ${lateEarlyPunchList[index].checkInTime}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Text(
                            'Early by : ${(DateTime.parse('2023-04-01T11:00:00').difference(DateTime.parse('2023-04-01T${lateEarlyPunchList[index].checkOutTime}'))).toString().substring(0, 7)} Out time : ${lateEarlyPunchList[index].checkOutTime}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ))
        : Center(
            child: Text(_index == 0
                ? 'All employees come on time for sift'
                : 'No employees swipe before sift end'),
          );
  }
}
