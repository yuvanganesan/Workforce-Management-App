import './models/dashboard_menu.dart';
import './screens/daily_attendence.dart';
import './screens/late_early_punch.dart';
import './screens/nfc.dart';
import './screens/ot_staff_select.dart';
import 'screens/ratings_screen.dart';

// ignore: constant_identifier_names
const DUMMY_DATA = [
  DashboardMenu('Attendence', 'assets/images/day.png', Attendence.routeName),
  DashboardMenu(
      'L&E Punch', 'assets/images/delay.png', LateAndEarlyPunch.routeName),
  DashboardMenu('NFC', 'assets/images/nfca.png', NFC.routeName),
  DashboardMenu(
      'OT Staff', 'assets/images/sots.png', OtStaffSelection.routeName),
  DashboardMenu('Ratings', 'assets/images/review.png', RatingScreen.routeName),
  DashboardMenu('Temp', 'assets/images/temp.png', 'navigatingUrl')
];
