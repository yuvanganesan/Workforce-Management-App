import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../providers/employees.dart';
import '../providers/employee.dart';

class AllEmployees extends StatefulWidget {
  @override
  State<AllEmployees> createState() => _AllEmployeesState();
}

class _AllEmployeesState extends State<AllEmployees> {
  bool _isFirst = false;
  bool progressIndicator = false;
  @override
  void didChangeDependencies() async {
    if (!_isFirst) {
      setState(() {
        progressIndicator = true;
      });
      try {
        await Provider.of<Employees>(context, listen: false).fetchEmployee();
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Opps something went wrong'),
                  content: Text(error.toString()),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Okay'))
                  ],
                ));
      } finally {
        setState(() {
          progressIndicator = false;
        });
      }
      _isFirst = true;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final employees =
        Provider.of<Employees>(context, listen: false).allEmployees;
    final otEmployes =
        Provider.of<Employees>(context, listen: false).otEmployees;
    return Scaffold(
        body: progressIndicator == true
            ? const Center(child: CircularProgressIndicator())
            : employees.isEmpty
                ? const Center(
                    child: Text('There is no employees'),
                  )
                : ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                      value: employees[index],
                      child: SingleEmployee(),
                    ),
                  ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Chip(
                backgroundColor: Colors.purple,
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<Employees>(
                      builder: (context, otEmployees, child) => Text(
                            '${otEmployees.otEmployees.length}',
                            style: const TextStyle(color: Colors.white),
                          )),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 10),
              child:
                  //  Consumer<Employee>(
                  //   builder: (context, value, child) =>
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple, onPrimary: Colors.white),
                      onPressed: (otEmployes.isEmpty ||
                              otEmployes.any((otEmp) => otEmp.statusCode != 5))
                          //         &&
                          // _employees.any((emp) => emp.isModified == true)
                          ? () {
                              if (employees
                                  .any((emp) => emp.isModified == true)) {
                                try {
                                  Provider.of<Employees>(context, listen: false)
                                      .addOtEmployee();

                                  //print('success');
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
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('Okay'))
                                            ],
                                          ));
                                }
                              }
                            }
                          : null,
                      child: const Text('Save')),
            )
          ],
        ));
  }
}

class SingleEmployee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final singleEmployee = Provider.of<Employee>(context, listen: false);
    singleEmployee.todayOt =
        singleEmployee.statusCode == 1 || singleEmployee.statusCode == 5
            ? true
            : false;
    return Card(
      child: ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(singleEmployee.imgUrl)),
          title: Text(singleEmployee.name),
          subtitle: Text(singleEmployee.empId),
          trailing: Consumer<Employee>(
            builder: (context, singleEmployee, child) {
              return Checkbox(
                checkColor: Colors.purple,
                value: singleEmployee.todayOt,
                onChanged: (value) {
                  singleEmployee.setTodayOt(value!);
                },
              );
            },
          )),
    );
  }
}
