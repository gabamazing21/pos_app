import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/UI/SubMenu.dart';
import 'package:pos_app/UI/Items.dart';
import 'package:pos_app/UI/ItemLists.dart';
import 'package:pos_app/UI/Modifiers.dart';
import 'package:pos_app/UI/TransactionDetails.dart';
import 'package:pos_app/Utils/utils.dart';

class MasterPanelItem extends StatefulWidget{

  _MasterPanelItemState createState()=> _MasterPanelItemState();
}
class _MasterPanelItemState extends State{

Widget currentWidget;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MasterDetailScaffold(
          twoPanesWidthBreakpoint: 400,
          initialRoute: "Item",
          detailsRoute: "ItemList",
          masterPaneWidth: 250,
          initialDetailsPaneBuilder: (BuildContext context)=>ItemList(),

          detailsAppBar: AppBar(title: Text("Item",style: TextStyle(color: Colors.black),),backgroundColor: utils.getColorFromHex("#F1F1F1"),iconTheme: IconThemeData(color: Colors.black)),
          onDetailsPaneRouteChanged: (String route, Map<String, String> parameters){
            if(parameters==null){

              return;
            }
            print("onDetailsPanelRouteChanges $route $parameters");
            
            if(parameters["id"].contains("Items")){
              currentWidget=ItemList();
              print("value is item");
            }else if(parameters["id"].contains("Modifiers")){
             print("value is modifiers");
              currentWidget=Modifiers();

            }else if(parameters["id"].contains("SubMenu")){

              currentWidget=SubMenu();
            }
            setState(() {


            });
          },
          masterPaneBuilder: (BuildContext context)=>Item(),
          detailsPaneBuilder: (BuildContext context)=>currentWidget
          ,
        ),

      ),


    );


  }
}