import 'package:flutter/material.dart';
import './ot_salary.dart';
import './employee_attendence.dart';
import '../widgets/main_drawer.dart';
import '../widgets/home_top.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  Widget menuCard(String title, String imgUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Attendence') {
          Navigator.of(context).pushNamed(EmpAttendence.routeName);
        } else {
          Navigator.of(context).pushNamed(OtSalary.routeName);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: title == 'OT salary'
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  topRight: Radius.circular(40))
              : const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  topLeft: Radius.circular(40)),
        ),
        color: Colors.white54,
        margin: const EdgeInsets.all(30),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 30, left: 20),
            child: ListTile(
                title: Text(title, style: const TextStyle(fontSize: 20)),
                leading: Image.asset(
                  imgUrl,
                ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final cardMargin = width * .1;
    return Scaffold(
      drawer: const Drawer(
        child: MainDrawer(),
      ),
      body: Stack(children: [
        Container(
          color: Colors.purple,
          height: height,
          width: width,
          //  child: HomeTop(width: width, height: height),
        ),
        Column(
          children: [
            Container(
              color: Colors.purple,
              height: height * .4,
              width: width,
              child: HomeTop(width: width, height: height),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(90),
                      topLeft: Radius.circular(90))),
              height: height * .6,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    menuCard('Attendence', 'assets/images/day.png', context),
                    menuCard('OT salary', 'assets/images/salary.png', context),
                  ]),
            )
          ],
        ),
      ]),
    );
  }
}
