import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.dart';

class HomeTop extends StatelessWidget {
  const HomeTop({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final _empDetail =
        Provider.of<Authentication>(context, listen: false).empDetail;

    return LayoutBuilder(
      builder: (context, constraints) => Stack(children: [
        SizedBox(
          //color: Colors.purple,
          height: constraints.maxHeight,
          width: width,
        ),
        Positioned(
          top: constraints.maxHeight * .2,
          //height * .075,
          left: width * .075,
          child: Builder(builder: (context) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Image.asset(
                height: height * .04,
                'assets/images/left-align-2.png',
                color: Colors.white,
              ),
            );
          }),
        ),
        Positioned(
            top: constraints.maxHeight * .18,
            //height * .070,
            left: width * .18,
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: height * .04,
            )),
        Positioned(
            top: constraints.maxHeight * .18,
            //height * .070,
            right: width * .08,
            child: const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/st.jpg'))),
        Positioned(
            top: constraints.maxHeight * .35,
            //height * .15,
            left: width * .075,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Hi ${_empDetail.name}',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(_empDetail.designation,
                  style: const TextStyle(fontSize: 20, color: Colors.white))
            ])),
        /*     Positioned(
            left: width * .15,
            top: constraints.maxHeight * .70,
            //height * .28,
            child: Row(
              children: const [
                Card(
                  color: Colors.amberAccent,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '01',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '02',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '03',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '04',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ))*/
      ]),
    );
  }
}
