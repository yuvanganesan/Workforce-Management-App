import 'dart:async';

import 'package:flutter/material.dart';
import './dashboard.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 6), (() => Dashboard()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(203, 108, 230, 100),
      body: Container(),
    );
  }
}
//SplashScreen(
    //   backgroundColor: Color.fromRGBO(203, 108, 230, 100),
    //   seconds: 5,
    //   navigateAfterSeconds: new Dashboard(),
    //   image: Image.asset('assets/images/logo.png'),
    //   loadingText: new Text("Loading"),
    //   photoSize: 100.0,
    //   loaderColor: Color.fromRGBO(203, 108, 230, 0),
    // );