import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/UI/Demo.dart';
import 'package:pos_app/UI/Items.dart';
import 'package:pos_app/UI/MasterPanelItem.dart';
import 'package:pos_app/UI/MasterPanelTransaction.dart';
import 'package:pos_app/UI/TransactionDetails.dart';
import 'package:pos_app/UI/TransactionList.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/UI/dashboard.dart';

import 'package:pos_app/UI/menuDetails.dart';

class MasterPanel extends StatefulWidget {
  _MasterPanelState createState() => _MasterPanelState();
}

class _MasterPanelState extends State {
  String value;
  String routes;
  Widget _masterWidget = dashboard();
  Widget detailWidget;
  String action = "remove";

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
          initialDetailsPaneBuilder: (BuildContext context) =>
              menuDetails(null),
          //useObserver: true,
          detailsAppBar: AppBar(
            title: Text("Create $routes"),
          ),
          //AlternativeBulder: Demo(),
          onDetailsPaneRouteChanged:
              (String route, Map<String, String> parameters) {
            if (parameters == null) {
              print("parameter is null");
              return;
            }
            value = parameters["id"];
            routes = route;

            detailWidget = menuDetails(value);

            print("onDetailsPanelRouteChanges $value");
            setState(() {});
          },
          masterPaneBuilder: (BuildContext context) => _masterWidget,
          detailsPaneBuilder: (BuildContext context) => detailWidget,
//          pageRouteBuilder: (context,routes){
//             if(!routes.name.contains("MasterPanelTransactionList"))
//               {
//                     print("found ");
//
//                     return null;
//
//
//               }else{
//               print("not found");
//             }
//
//              print("mmmmmmmroutes $routes");
//          },
        ),
      ),
    );
  }
}
