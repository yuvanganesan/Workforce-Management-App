import 'package:flutter/material.dart';
import '../providers/ratings_provider.dart';
import '../models/ratings.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../widgets/ratings_card.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RatingScreen extends StatelessWidget {
  static const routeName = '/ratings';

  const RatingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: RatingsProvider(), child: const RatingsList());
  }
}

class RatingsList extends StatefulWidget {
  const RatingsList({Key? key}) : super(key: key);

  @override
  State<RatingsList> createState() => _RatingsListState();
}

class _RatingsListState extends State<RatingsList> {
  DateTime? date;
  bool submitFlag = false;
  bool progressIndicator = false;
  List<Ratings> empList = [];

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
        empList = [];
      });
    });
  }

  void showToast(String _msg, Color color) {
    Fluttertoast.showToast(
        msg: _msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: color);
    //Fluttertoast.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ratings"),
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
                          //print('try');

                          await Provider.of<RatingsProvider>(context,
                                  listen: false)
                              .fetchDropDownItem();

                          // ignore: use_build_context_synchronously
                          await Provider.of<RatingsProvider>(context,
                                  listen: false)
                              .fetchRatingCardList(date!);

                          submitFlag = true;
                          //print('flag true');
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
        Consumer<RatingsProvider>(builder: ((context, _, child) {
          if (submitFlag == true) {
            empList = Provider.of<RatingsProvider>(context, listen: false)
                .empRatingCardList;
          }
          return Expanded(
              child: progressIndicator == true
                  ? const Center(child: CircularProgressIndicator())
                  : empList.isNotEmpty
                      ? RatingsCard(empList)
                      : Center(
                          child: Text(submitFlag == true
                              ? 'The date you selected was leave'
                              : 'Choose date and submit')));
        }))
      ]),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.purple, onPrimary: Colors.white),
                onPressed: () {
                  if (empList.every(
                      (emp) => emp.stageId != '0' && emp.ratingStar > 0)) {
                    try {
                      if (empList.any((emp) => emp.isModified == true)) {
                        Provider.of<RatingsProvider>(context, listen: false)
                            .saveRatings();
                        showToast('Saved successfuly',
                            Color.fromRGBO(55, 157, 0, 100));
                        //while api call make all ismodified false
                        // throw Error();
                      } else {
                        showToast('There is no modification',
                            Color.fromRGBO(255, 197, 0, 100));
                      }
                    } catch (error) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Opps something went wrong'),
                                content: Text(error.toString()),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Okay'))
                                ],
                              ));
                    }
                  } else {
                    showToast(' All fields are required',
                        Color.fromRGBO(255, 197, 0, 100));
                  }
                },
                child: const Text('Save')),
          )
        ],
      ),
    );
  }
}
