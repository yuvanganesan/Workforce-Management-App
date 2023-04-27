import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/attendence_card.dart';
import '../providers/attendenceList.dart';

class AttendenceCardList extends StatefulWidget {
  const AttendenceCardList({Key? key}) : super(key: key);

  @override
  State<AttendenceCardList> createState() => _AttendenceCardListState();
}

class _AttendenceCardListState extends State<AttendenceCardList> {
  DateTime? date;
  List<AttendenceCard> empAttendenceList = [];
  bool submitFlag = false;
  bool progressIndicator = false;

  void datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023, 4, 1),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        date = value;
        empAttendenceList = [];
        submitFlag = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                        setState(() {
                          progressIndicator = true;
                          // print('progress true');
                        });
                        try {
                          // print('enter try');
                          await Provider.of<AttendenceList>(context,
                                  listen: false)
                              .fetchAttendence(date!);
                          submitFlag = true;
                          // if (Provider.of<AttendenceList>(context,
                          //             listen: false)
                          //         .attendenceList
                          //         .length ==
                          //     0) {
                          //   dialogBox(HttpException('There is no record'));
                          // }

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
        ),
        Consumer<AttendenceList>(
          builder: (context, _, child) {
            if (submitFlag == true) {
              // print('emoAL getter');
              empAttendenceList =
                  Provider.of<AttendenceList>(context, listen: false)
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
                                    leading: CircleAvatar(
                                        backgroundColor: Colors.purpleAccent,
                                        child: Text(
                                          empAttendenceList[index].id,
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    title: Text(empAttendenceList[index].name),
                                    subtitle: empAttendenceList[index]
                                                .checkInTime !=
                                            'A'
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
                                                ? Colors.lightGreen
                                                : Colors.red,
                                        child: Text(
                                          // ignore: unnecessary_null_comparison
                                          empAttendenceList[index]
                                                      .checkInTime !=
                                                  'A'
                                              ? 'P'
                                              : 'A',
                                          style: TextStyle(color: Colors.white),
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
    );
  }
}
