import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/UI/MasterPanel.dart';
import 'package:pos_app/UI/MasterPanelItem.dart';
import 'package:pos_app/UI/MasterPanelTransaction.dart';

class Demo extends StatefulWidget{

_DemoState createState()=> _DemoState();

}

class _DemoState extends State{


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text("Home"),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          alignment: Alignment.center,
          child: FlatButton(onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MasterPanelTransaction()));

          }, child: Text("Go To Menu")),

        ),
      ),
    );

  }
}