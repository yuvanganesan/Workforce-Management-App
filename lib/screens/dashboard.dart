import 'package:flutter/material.dart';
import '../widgets/menu_grid.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.purple),
              width: width * .5,
              height: height,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
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
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(90))),
              height: height * .4,
              width: width,
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(90))),
              height: height * .6,
              width: width,
              child: MenuGrid(),
            )
          ],
        )
      ]),
    );
  }
}
