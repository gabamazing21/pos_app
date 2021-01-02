import 'dart:async';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Timer(
    //     Duration(seconds: 3),
    //     () => PasscodeScreen(
    //         title: Text('Enter Passcode'),
    //         passwordEnteredCallback: null,
    //         cancelButton: null,
    //         deleteButton: null,
    //         shouldTriggerVerification: null));

    return Center(
        child: Container(
      child: Image.asset(
        "assets/images/start_logo.png",
      ),
    ));
  }
}
