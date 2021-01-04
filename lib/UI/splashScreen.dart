import 'dart:async';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:pos_app/UI/pass_code.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Image.asset(
        "assets/images/start_logo.png",
      ),
    ));
  }

  // Future<bool> getPasscodeIsRegistered() async {
  //   final snapshot =
  //       await Firestore.instance.collection('passcode').getDocuments();
  //   if (snapshot.documents.length == 0) {
  //     //Doesn't exist
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (BuildContext context) => PassCode()),
  //     );
  //   } else {}
  // }
}
