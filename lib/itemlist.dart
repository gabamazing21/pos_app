import 'package:flutter/material.dart';

class itemlist extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Text("Learning masterpanel",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

    );

  }
}