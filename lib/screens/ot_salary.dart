import 'package:flutter/material.dart';
import '../providers/authentication.dart';
import '../models/salary_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/ot_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtSalary extends StatefulWidget {
  static const routeName = '/otSalary';
  const OtSalary({super.key});

  @override
  State<OtSalary> createState() => _OtSalaryState();
}

class _OtSalaryState extends State<OtSalary> {
  DateTime? date1;
  DateTime? date2;
  List<SalaryCard> salaryCardList = [];
  String total = '0.0';
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
        total = '0.0';
        salaryCardList = [];
        submitFlag = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OT Salary')),
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
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple),
                onPressed: date1 != null && date2 != null
                    ? () async {
                        if (date2!.isBefore(date1!)) {
                          Fluttertoast.showToast(
                              textColor: Colors.black,
                              msg: 'End date can\'t before start date',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              backgroundColor:
                                  const Color.fromRGBO(255, 197, 0, 100));
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
                          await Provider.of<OtDetail>(context, listen: false)
                              .fetchOtSalary(int.parse(empId), date1!, date2!);
                          //int.parse(empId)
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
          Consumer<OtDetail>(
            builder: (context, _, child) {
              if (submitFlag == true) {
                // print('emoAL getter');
                salaryCardList = Provider.of<OtDetail>(context, listen: false)
                    .salaryCardList;
              }
              // print('Consumer');
              return progressIndicator == true
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : salaryCardList.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: salaryCardList.length,
                              itemBuilder: (context, index) => Card(
                                    child: ListTile(
                                      leading: Text(salaryCardList[index].date),
                                      title: Text(
                                        'H : ${salaryCardList[index].workHours}\t\t\t\tM : ${salaryCardList[index].workMins}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      subtitle: Text(
                                        'In : ${salaryCardList[index].inTime.substring(0, 5)} Out : ${salaryCardList[index].outTime.substring(0, 5)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              const Color(0xffe2762b),
                                          child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                '₹${salaryCardList[index].otSalary}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ))),
                                    ),
                                  )))
                      : Expanded(
                          child: Center(
                              child: Text(submitFlag == true
                                  ? 'The date you selected was leave'
                                  : 'Choose date and submit')));
            },
          )
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Total  ",
            style: TextStyle(fontSize: 20),
          ),
          Consumer<OtDetail>(builder: (context, _, child) {
            if (submitFlag == true) {
              // print('emoAL getter');
              total =
                  Provider.of<OtDetail>(context, listen: false).totalOtSalary;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                  backgroundColor: Colors.purple,
                  label: Text(
                    '₹$total',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )),
            );
          })
        ],
      ),
    );
  }
}
