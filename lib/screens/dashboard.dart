import 'package:flutter/material.dart';
import '../widgets/menu_grid.dart';
import '../widgets/home_top.dart';
import '../widgets/main_drawer.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const Drawer(
        child: MainDrawer(),
      ),
      body: Stack(children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              width: width * .5,
              height: height,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.purple),
              width: width * .5,
              height: height,
            )
          ],
        ),
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                  )),
              height: height * .4,
              width: width,
              child: HomeTop(width: width, height: height),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(90))),
              height: height * .6,
              width: width,
              child: MenuGrid(),
            )
          ],
        ),
      ]),
    );
  }
}
