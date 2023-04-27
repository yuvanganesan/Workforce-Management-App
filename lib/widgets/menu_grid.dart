import 'package:flutter/material.dart';
import '../dummy_data.dart';
import './single_menu.dart';
import 'package:provider/provider.dart';
import '../providers/attendenceList.dart';

class MenuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              height: constraints.maxHeight,
              padding: EdgeInsets.only(
                  top: constraints.maxHeight * 0.05,
                  bottom: constraints.maxHeight * 0.05),
              child: GridView(
                physics: constraints.maxHeight > 300
                    ? const NeverScrollableScrollPhysics()
                    : null,
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                children: DUMMY_DATA.map(((menu) {
                  return SingleMenu(menu);
                })).toList(),
              ),
            ));
  }
}
