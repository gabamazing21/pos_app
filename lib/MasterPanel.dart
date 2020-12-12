import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/dashboard.dart';
import 'package:pos_app/itemlist.dart';
import 'package:pos_app/menuDetails.dart';

class MasterPanel extends StatefulWidget{


  _MasterPanelState createState()=>_MasterPanelState();
}
class _MasterPanelState extends State{


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
          initialDetailsPaneBuilder: (BuildContext context)=>menuDetails(),
          detailsAppBar: AppBar(),
          onDetailsPaneRouteChanged: (String route, Map<String, String> parameters){
            print("onDetailsPanelRouteChanges $route");
setState(() {

});
          },
          masterPaneBuilder: (BuildContext context)=>dashboard(),
          detailsPaneBuilder: (BuildContext context)=>menuDetails(),



        ),

      ),

    );

  }
}