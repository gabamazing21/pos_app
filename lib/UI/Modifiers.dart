import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/Item.dart';
import 'package:pos_app/Models/modifier.dart';
import 'package:pos_app/UI/ModifiersDetails.dart';
import 'package:pos_app/Utils/utils.dart';

class Modifiers extends StatefulWidget {
  _ModifierState createState() => _ModifierState();
}

class _ModifierState extends State {
  TextEditingController _searchController = TextEditingController();
  bool showEditModifiers = false;
  List<Item> foodlist = List();
  List<modifiers> modifiersList = List();
  modifiers currentModifier;
  @override
  void initState() {
    getModifiersList();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return (!showEditModifiers)
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Modifiers",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
              backgroundColor: utils.getColorFromHex("#F1F1F1"),
            ),
            body: SafeArea(
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    /** Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: utils.getColorFromHex("#F1F1F1"),
                  child: Text("All Items",style: TextStyle(fontSize: 16,color: Colors.black), ),

                  ),**/

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Search Modifiers",
                          suffixIcon: Icon(
                            Icons.search,
                            size: 25,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        currentModifier = null;
                        setState(() {
                          showEditModifiers = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: FlatButton(
                          child: Text(
                            "Add Modifiers",
                            style: TextStyle(
                                fontSize: 16,
                                color: utils.getColorFromHex("#0D97FF")),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 218,
                      child: ListView.builder(
                        itemCount: modifiersList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                                onTap: () {
                                  currentModifier =
                                      modifiersList.elementAt(index);
                                  setState(() {
                                    showEditModifiers = true;
                                  });
                                },
                                child:
                                    _orderItem(modifiersList.elementAt(index))),
                      ),
                    )
                  ],
                ),
              ),
            ))
        : ModifiersDetails(currentModifier, () {
            setState(() {
              showEditModifiers = false;
            });
          });
  }

  Widget _orderItem(modifiers item) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 20,
                )),
          ),
          Positioned(
              top: 5,
              left: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.modifier_name}",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              )),
          Positioned(
              top: 10,
              right: 10,
              child: Text(
                item.items.length > 1
                    ? "${item.items.length} items"
                    : "${item.items.length} item",
                style: TextStyle(
                    fontSize: 18, color: Colors.black.withOpacity(0.5)),
              )),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Divider(
              height: 1,
              color: Colors.black.withOpacity(0.8),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getModifiersList() async {
    modifiersList.clear();
    modifiersList = await database.getAllModifier();
    if (modifiersList.isEmpty) {
      getModifiersList();
    } else {
      setState(() {});
    }
  }
}
