import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/UI/TransactionDetails.dart';
import 'package:pos_app/UI/TransactionList.dart';
import 'package:pos_app/UI/printing.dart';
import 'package:pos_app/Utils/tempovalue.dart';
import 'package:pos_app/Utils/utils.dart';

class MasterPanelTransaction extends StatefulWidget {
  _MasterPanelTransactionState createState() => _MasterPanelTransactionState();
}

class _MasterPanelTransactionState extends State {
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  Widget detaillayout = TransactionDetails();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MasterDetailScaffold(
          twoPanesWidthBreakpoint: 400,
          initialRoute: "TransactionList",
          detailsRoute: "TransactionDetails",
          masterPaneWidth: 250,
          initialDetailsPaneBuilder: (BuildContext context) =>
              TransactionDetails(),
          detailsAppBar: AppBar(
            title: Text(
              utils.localcurrency(7.30),
            ),
            backgroundColor: utils.getColorFromHex("#F1F1F1"),
          ),
          onDetailsPaneRouteChanged:
              (String route, Map<String, String> parameters) {
            if (parameters == null) {
              return;
            }

            if (parameters['id'].contains("printing")) {
              // detaillayout =
              //     MyPrint(tempovalueInstance.getInstance().currentOrderDetials);
            } else {
              detaillayout = TransactionDetails();
            }
            print("onDetailsPanelRouteChanges $route");
            setState(() {});
          },
          masterPaneBuilder: (BuildContext context) => TransactionList(),
          detailsPaneBuilder: (BuildContext context) => detaillayout,
        ),
      ),
    );
  }
}
