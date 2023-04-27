import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../providers/employees.dart';

class OtEmployees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final otEmployees =
        Provider.of<Employees>(context, listen: false).otEmployees;
    return Scaffold(
      body: otEmployees.isEmpty
          ? const Center(
              child: Text('No employees selected for OT.'),
            )
          : ListView.builder(
              itemCount: otEmployees.length,
              itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(otEmployees[index].imgUrl)),
                      title: Text(otEmployees[index].name),
                      subtitle: Text(otEmployees[index].empId),
                    ),
                  )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Chip(
              backgroundColor: Colors.purple,
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${otEmployees.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: Consumer<Employees>(
                builder: (context, confirm, _) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple, onPrimary: Colors.white),
                      onPressed: otEmployees.isNotEmpty &&
                              otEmployees.any((otEmp) => otEmp.statusCode != 5)
                          ? () {
                              try {
                                confirm.otConfirm();
                              } catch (error) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Opps something went wrong'),
                                          content: Text(error.toString()),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text('Okay'))
                                          ],
                                        ));
                              }

                              // Provider.of<Employees>(context, listen: true).otConfirm();
                            }
                          : null,
                      child: const Text('Confirm'),
                    )),
          ),
        ],
      ),
    );
  }
}
