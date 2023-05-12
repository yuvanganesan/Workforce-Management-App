import 'package:flutter/material.dart';
import '../providers/authentication.dart';
import '../models/attendence_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/single_emp_attendence.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmpAttendence extends StatefulWidget {
  static const routeName = '/empAttendence';
  const EmpAttendence({super.key});

  @override
  State<EmpAttendence> createState() => _EmpAttendenceState();
}

class _EmpAttendenceState extends State<EmpAttendence> {
  DateTime? date1;
  DateTime? date2;
  List<AttendenceCard> empAttendenceList = [];
  bool submitFlag = false;
  bool progressIndicator = false;

  void datePicker(bool flag) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023, 4, 1),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        if (flag) {
          date1 = value;
        } else {
          date2 = value;
        }
        //  date1 = value;
        empAttendenceList = [];
        submitFlag = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DBA')),
      body: Column(
        children: [
          Card(
              child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => datePicker(true),
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text(
                    'Start Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: date1 == null
                      ? const Text(
                          'No Date  Choosen',
                        )
                      : Text(DateFormat('dd/MM/yy').format(date1!))),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => datePicker(false),
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text(
                    'End Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: date2 == null
                      ? const Text(
                          'No Date  Choosen',
                        )
                      : Text(DateFormat('dd/MM/yy').format(date2!))),
            ],
          )),
          ListTile(
            title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.purple, onPrimary: Colors.white),
                onPressed: date1 != null && date2 != null
                    ? () async {
                        if (date2!.isBefore(date1!)) {
                          Fluttertoast.showToast(
                              textColor: Colors.black,
                              msg: 'End date can\'t before start date',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              backgroundColor:
                                  Color.fromRGBO(255, 197, 0, 100));
                          return;
                        }
                        final empId =
                            Provider.of<Authentication>(context, listen: false)
                                .empDetail
                                .empId;

                        setState(() {
                          progressIndicator = true;
                          // print('progress true');
                        });
                        try {
                          // print('enter try');
                          await Provider.of<SingleEmpAttendence>(context,
                                  listen: false)
                              .fetchAttendence(
                                  int.parse(empId), date1!, date2!);
                          submitFlag = true;

                          // print('submit true');
                        } catch (error) {
                          // print('error= ${error.toString()}');
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
                            // print('progress false');
                            progressIndicator = false;
                          });
                        }
                      }
                    : null,
                child: const Text('Submit')),
          ),
          Consumer<SingleEmpAttendence>(
            builder: (context, _, child) {
              if (submitFlag == true) {
                // print('emoAL getter');
                empAttendenceList =
                    Provider.of<SingleEmpAttendence>(context, listen: false)
                        .attendenceList;
              }
              // print('Consumer');
              return progressIndicator == true
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : empAttendenceList.length > 0
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: empAttendenceList.length,
                              itemBuilder: (context, index) => Card(
                                    child: ListTile(
                                      leading:
                                          Text(empAttendenceList[index].date),
                                      title: Text(empAttendenceList[index].day),
                                      subtitle: empAttendenceList[index]
                                                      .checkInTime !=
                                                  'A' &&
                                              empAttendenceList[index]
                                                      .checkInTime !=
                                                  'H'
                                          ? Text(
                                              'In : ${empAttendenceList[index].checkInTime.substring(0, 5)} Out : ${empAttendenceList[index].checkOutTime.substring(0, 5)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Text(
                                              'In :  Out :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      trailing: CircleAvatar(
                                          backgroundColor:
                                              empAttendenceList[index]
                                                          .checkInTime !=
                                                      'A'
                                                  ? empAttendenceList[index]
                                                              .checkInTime !=
                                                          'H'
                                                      ? Colors.lightGreen
                                                      : Colors.amberAccent
                                                  : Colors.red,
                                          child: Text(
                                            // ignore: unnecessary_null_comparison
                                            empAttendenceList[index]
                                                        .checkInTime !=
                                                    'A'
                                                ? empAttendenceList[index]
                                                            .checkInTime !=
                                                        'H'
                                                    ? 'P'
                                                    : 'H'
                                                : 'A',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  )),
                        )
                      : Expanded(
                          child: Center(
                              child: Text(submitFlag == true
                                  ? 'The date you selected was leave'
                                  : 'Choose date and submit')));
            },
          )
        ],
      ),
    );
  }
}
