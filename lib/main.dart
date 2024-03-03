import 'package:flutter/material.dart';
import './screens/employee_attendence.dart';
import './screens/ot_salary.dart';
import './screens/dashboard.dart';
import './screens/daily_attendence.dart';
import './screens/late_early_punch.dart';
import './screens/nfc.dart';
import './screens/ot_staff_select.dart';
import './screens/ratings_screen.dart';
import 'package:flutter/services.dart';
import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './providers/authentication.dart';
import './screens/employee_dashboard.dart';
import './providers/attendenceList.dart';
import './providers/single_emp_attendence.dart';
import './providers/ot_detail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        ),
        ChangeNotifierProvider.value(value: AttendenceList()),
        ChangeNotifierProvider.value(value: SingleEmpAttendence()),
        ChangeNotifierProvider.value(value: OtDetail())
      ],
      child: MaterialApp(
          theme: ThemeData(
              appBarTheme: const AppBarTheme(color: Color(0xffcb6ce6)),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.white)),
          debugShowCheckedModeBanner: false,
          title: "Workforce Management App",
          home: Consumer<Authentication>(
            builder: (context, _auth, child) {
              return _auth.isAuth == false
                  ? const AuthScreen()
                  : _auth.empDetail.isStaff == true
                      ? const Dashboard()
                      : EmployeeDashboard();
            },
          ),
          routes: {
            Attendence.routeName: (context) => Attendence(),
            LateAndEarlyPunch.routeName: (context) => LateAndEarlyPunch(),
            NFC.routeName: (context) => NFC(),
            OtStaffSelection.routeName: (context) => OtStaffSelection(),
            RatingScreen.routeName: (context) => RatingScreen(),
            EmpAttendence.routeName: (context) => EmpAttendence(),
            OtSalary.routeName: (context) => OtSalary()
          }),
    );
  }
}
