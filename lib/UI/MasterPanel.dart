import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/UI/dashboard.dart';

import 'package:pos_app/UI/menuDetails.dart';

class MasterPanel extends StatefulWidget{


  _MasterPanelState createState()=>_MasterPanelState();
}
class _MasterPanelState extends State{
String value;
String routes;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MasterDetailScaffold(
          twoPanesWidthBreakpoint: 400,
          initialRoute: "dashboard",
          detailsRoute: "menuDetails",
          masterPaneWidth: 250,
          initialDetailsPaneBuilder: (BuildContext context)=>menuDetails(null),
          detailsAppBar: AppBar(title: Text("Create $routes"),),
          onDetailsPaneRouteChanged: (String route, Map<String, String> parameters){
          if(parameters==null){
            print("parameter is null");
            return;
          }
           value=  parameters["id"];
          routes=route;
            print("onDetailsPanelRouteChanges $value");
setState(() {

});
          },
          masterPaneBuilder: (BuildContext context)=>dashboard(),
          detailsPaneBuilder: (BuildContext context)=>menuDetails(value),



        ),

      ),

    );

  }
}