import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/Item.dart';
import 'package:pos_app/UI/MasterPanel.dart';
import 'package:pos_app/UI/MasterPanelItem.dart';
import 'package:pos_app/UI/MasterPanelTransaction.dart';
import 'package:pos_app/Utils/constants.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/UI/pass_code.dart';

class Item extends StatefulWidget {
  _ItemState createState() => _ItemState();
}

class _ItemState extends State {
  int _selected = 0;
  List<Item> itemList = List();
  List<String> itemName = ["Items", "Modifiers", "SubMenu"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: utils.getColorFromHex("#3D3D3D"),
          child: Stack(
            children: [
              Positioned(
                  right: 10,
                  top: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: utils.getColorFromHex("#878787")),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  )),
              Positioned(
                  top: 80,
                  left: 20,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Container(
                    child: ListView(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PassCode(
                                  voidCallback: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MasterPanel()),
                                        (route) => false);
                                  },
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text("Menu", style: KdashboardTextStyle),
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MasterPanelTransaction(),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(
                                "Orders",
                                style: KdashboardTextStyle,
                              ),
                            )),
                        GestureDetector(
                          onTap: () async {
                            print("clicked");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PassCode(
                                        voidCallback: () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MasterPanelItem()),
                                                  (route) => false);
                                        },
                                      )),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              "Activities",
                              style: KdashboardTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Item",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: utils.getColorFromHex("#F1F1F1"),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) =>
              _Item(itemName[index], index),
        ),
      ),
    );
  }

  Widget _Item(String text, int index) {
    return GestureDetector(
      onTap: () {
        _selected = index;
        setState(() {});
        MasterDetailScaffold.of(context)
            .detailsPaneNavigator
            .pushNamed("ItemList?id=$text");
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        color: (_selected == index)
            ? utils.getColorFromHex("#3D3D3D")
            : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "${text}",
                  style: TextStyle(
                    fontSize: 20,
                    color: (_selected == index) ? Colors.white : Colors.black,
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 0),
              width: MediaQuery.of(context).size.width,
              child: Divider(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
