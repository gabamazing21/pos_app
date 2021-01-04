import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/UI/MasterPanel.dart';
import 'package:pos_app/UI/MasterPanelTransaction.dart';
import 'package:pos_app/UI/createPasscode.dart';
import 'package:pos_app/Utils/tempovalue.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToNext();
  }

  goToNext() {
    FirebaseFirestore.instance.collection("passCode").get().then((value) {
      if (value.size == 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => createPasscode()));
      } else {
        String id = value.docs.elementAt(0).id;
        String code = value.docs.elementAt(0)['code'];
        FirebaseFirestore.instance
            .collection("passCode")
            .doc(id)
            .update({"lastTimeLogin": DateTime.now()}).then((value) {
          tempovalueInstance.getInstance().passcode = code;

          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MasterPanelTransaction()));
        });
      }
    });
  }
}
