import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../widgets/menu_grid.dart';

class TempDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.purple),
              width: width * .5,
              height: height,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
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
              child: MenuGrid(),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(90))),
              height: height * .6,
              width: width,
            )
          ],
        )
      ]),
      //     body: Column(
      //   children: [
      //     Container(
      //       child: Stack(children: [
      //         Row(
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(color: Colors.purple),
      //               width: width * .5,
      //             ),
      //             Container(
      //               decoration: BoxDecoration(color: Colors.white),
      //               width: width * .5,
      //             )
      //           ],
      //         ),
      //         Container(
      //           decoration: BoxDecoration(
      //               color: Colors.purple,
      //               borderRadius:
      //                   BorderRadius.only(bottomRight: Radius.circular(90))),
      //           width: width,
      //         )
      //       ]),
      //       height: height * .4,
      //     ),
      //     Container(
      //       child: Stack(children: [
      //         Row(
      //           children: [
      //             Container(
      //               decoration: BoxDecoration(color: Colors.purple),
      //               width: width * .5,
      //             ),
      //             Container(
      //               decoration: BoxDecoration(color: Colors.white),
      //               width: width * .5,
      //             )
      //           ],
      //         ),
      //         Container(
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius:
      //                   BorderRadius.only(topLeft: Radius.circular(90))),
      //           width: width,
      //         )
      //       ]),
      //       height: height * .6,
      //     )
      //   ],
      // )
    );
  }
}
