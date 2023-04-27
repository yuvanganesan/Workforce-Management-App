import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendence_card.dart';
import '../widgets/late_early_list.dart';
import 'package:provider/provider.dart';
import '../providers/attendenceList.dart';

class LateAndEarlyPunch extends StatefulWidget {
  static const routeName = '/lateandearlypunch';

  @override
  State<LateAndEarlyPunch> createState() => _LateAndEarlyPunchState();
}

class _LateAndEarlyPunchState extends State<LateAndEarlyPunch> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: AttendenceList(), child: const LateEarlyNavigation());
  }
}

class LateEarlyNavigation extends StatefulWidget {
  const LateEarlyNavigation({Key? key}) : super(key: key);

  @override
  State<LateEarlyNavigation> createState() => _LateEarlyNavigationState();
}

class _LateEarlyNavigationState extends State<LateEarlyNavigation> {
  int _index = 0;
  DateTime? date;
  bool submitFlag = false;
  bool progressIndicator = false;
  List<AttendenceCard> empAttendenceList = [];
  //List<Widget> leWidget = [LatePunch(), EarlyPunch()];

  void datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023, 4, 1),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        date = value;
        submitFlag = false;
        empAttendenceList = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LateAndEarlyPunch"),
      ),
      body: Column(children: [
        Card(
          child: ListTile(
            leading: TextButton(
              onPressed: datePicker,
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: const Text(
                'Choose Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: date == null
                ? const Text(
                    'No Date  Chossen',
                  )
                : Text(DateFormat('dd/MM/yy').format(date!)),
            trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.purple, onPrimary: Colors.white),
                onPressed: date != null
                    ? () async {
                        //print('submited');
                        setState(() {
                          progressIndicator = true;
                        });
                        try {
                          await Provider.of<AttendenceList>(context,
                                  listen: false)
                              .fetchAttendence(date!);

                          submitFlag = true;
                        } catch (error) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title:
                                        const Text('Opps something went wrong'),
                                    content: Text(error.toString()),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Okay'))
                                    ],
                                  ));
                        } finally {
                          setState(() {
                            progressIndicator = false;
                          });
                        }
                      }
                    : null,
                child: const Text('Submit')),
          ),
        ),
        Consumer<AttendenceList>(builder: ((context, _, child) {
          if (submitFlag == true) {
            empAttendenceList =
                Provider.of<AttendenceList>(context, listen: false).presentList;
          }
          return Expanded(
              child: progressIndicator == true
                  ? Center(child: CircularProgressIndicator())
                  : empAttendenceList.length > 0
                      ? LatePunch(_index)
                      : Center(
                          child: Text(submitFlag == true
                              ? 'The date you selected was leave'
                              : 'Choose date and submit')));
        }))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon:
                  // Container(
                  //     height: 25,
                  //     child: Image.asset(
                  //       'assets/icons/delay.png',
                  //       fit: BoxFit.cover,
                  //     ))
                  Icon(Icons.alarm),
              label: 'Late Punch'),
          BottomNavigationBarItem(
              icon:
                  //  Container(
                  //     height: 25,
                  //     child: Image.asset(
                  //       'assets/icons/early.png',
                  //       //color: Colors.white,
                  //       fit: BoxFit.cover,
                  //     ))
                  Icon(Icons.campaign),
              label: 'Early Punch')
        ],
        currentIndex: _index,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.purple,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
