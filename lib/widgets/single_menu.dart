import 'package:flutter/material.dart';
import '../models/dashboard_menu.dart';
import 'package:provider/provider.dart';
import '../providers/attendenceList.dart';

class SingleMenu extends StatelessWidget {
  final DashboardMenu menu;

  const SingleMenu(this.menu);
  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return InkWell(
      onTap: (() {
        if (menu.title != 'Temp') {
          Navigator.of(context).pushNamed(menu.navigatingUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Currently this feature is not available",
                textAlign: TextAlign.center),
          ));
        }
      }),
      child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child: Image.asset(
                  menu.imgUrl,
                  fit: BoxFit.cover,
                )),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    menu.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15 * textScaleFactor),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
