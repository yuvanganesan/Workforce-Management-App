import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './screens/dashboard.dart';
import './screens/daily_attendence.dart';
import './screens/late_early_punch.dart';
import './screens/nfc.dart';
import './screens/ot_staff_select.dart';
import 'screens/ratings_screen.dart';
import 'package:flutter/services.dart';

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
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.white,
            appBarTheme: const AppBarTheme(color: Colors.purple)),
        debugShowCheckedModeBanner: false,
        title: "wagesUI",
        home: Dashboard(), //TempDashboard(), //FirstScreen() Splash(),
        routes: {
          Attendence.routeName: (context) => Attendence(),
          LateAndEarlyPunch.routeName: (context) => LateAndEarlyPunch(),
          NFC.routeName: (context) => NFC(),
          OtStaffSelection.routeName: (context) => OtStaffSelection(),
          RatingScreen.routeName: (context) => RatingScreen()
        });
  }
}
