import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/Item.dart';
import 'package:pos_app/Models/modifier.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/component/tool_bar.dart';

class ModifiersDetails extends StatefulWidget {
  final modifiers currentModifiers;
  VoidCallback voidCallback;

  ModifiersDetails(this.currentModifiers, this.voidCallback);

  _ModifiersDetailsState createState() => _ModifiersDetailsState(
      currentModifiers: currentModifiers, voidCallback: voidCallback);
}

class _ModifiersDetailsState extends State {
  bool isloading = false;
  String modifierName = null;
  bool isModifierError = false;
  List<Item> foodlist = List();
  TextEditingController _modifiersName = TextEditingController();
  List<Item> foodInModifiers = List();
  bool ischeckbox = false;
  int quantity = 0;
  final modifiers currentModifiers;
  final VoidCallback voidCallback;

  _ModifiersDetailsState({this.currentModifiers, this.voidCallback});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (currentModifiers != null) {
      _modifiersName.text = currentModifiers.modifier_name;
      ischeckbox = currentModifiers.checkboxreq;
      quantity = currentModifiers.required_item_num;
      getFoodInModifiers();
    }
    getFoodlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolBar(
              callback: voidCallback,
              title: (currentModifiers == null)
                  ? 'Create Modifiers'
                  : 'Edit Modifiers',
            ),

            Column(

               mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 30, left: 0, right: 0),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _modifiersName,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        onChanged: (text) {
                          if (text.length < 2) {
                            modifierName = "Modifiers is required";
                            isModifierError = true;
                            print("menu error $modifierName");
                          } else {
                            modifierName = null;
                            isModifierError = false;
                            print("menu error  $modifierName");
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            labelText: "Enter item name",
                            hasFloatingPlaceholder: false,
                            labelStyle: TextStyle(
                                color: utils.getColorFromHex("#979797"),
                                fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: utils.getColorFromHex("#979797")),
                            ),
                            errorText: modifierName,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: utils.getColorFromHex("#CB0000"))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: utils.getColorFromHex("#979797")),
                            ))),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Divider(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "Options",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: Divider(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Visibility(
                    child: Container(
                  margin: EdgeInsets.only(left: 20, top: 5),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 0,
                        child: Text(
                          "CheckBox Option",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Checkbox(
                            value: ischeckbox,
                            onChanged: (vale) {
                              setState(() {
                                ischeckbox = vale;
                              });
                            },
                            activeColor: utils.getColorFromHex("#CB0000"),
                            checkColor: Colors.white,
                            focusColor: Colors.black.withOpacity(0.3),
                          ))
                    ],
                  ),
                )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0, bottom: 10, right: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 20, left: 20),
                              child: Text(
                                "Minimum Item Required",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                            Container(
                                child: Row(children: [
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 0) {
                                    setState(() {
                                      quantity = quantity - 1;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 36,
                                  width: 33,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: utils.getColorFromHex("#E0E0E0"),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "${quantity}",
                                  style:
                                      TextStyle(fontSize: 25, color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity = quantity + 1;
                                  });

                                  if (quantity == 1) {
                                  } else {}
                                },
                                child: Container(
                                  height: 36,
                                  width: 33,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: utils.getColorFromHex("#FF6700"),
                                  ),
                                ),
                              )
                            ]))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: Divider(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: 20),
                  child: Text(
                    "Items",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: Divider(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0 * foodInModifiers.length,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 503 - 142),
                  child: ListView.builder(
                    itemCount: foodInModifiers.length,
                    itemBuilder: (BuildContext context, int index) =>
                        MenuItem(foodInModifiers.elementAt(index)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showFoodList();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Add Items",
                      style: TextStyle(
                          fontSize: 16, color: Colors.black.withOpacity(0.5)),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Divider(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  color: Colors.red,
                  child: FlatButton(
                    onPressed: () {
                      if (!isloading) {
                        //  addMenuItem();
                        if (currentModifiers == null) {
                          saveModifiers();
                        } else {
                          updateModifiers();
                        }
                      } else {
                        print("loading...");
                      }
                    },
                    child: (!isloading)?Text(
                      (currentModifiers == null) ? "Save" : "Update",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ):Container(

                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          value: null,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),


                        )
                    ),

                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTopToolbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(top: 25),
      child: Stack(
        children: [
          Positioned(
              left: 10,
              top: 15,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    //addItem=false;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
          Positioned(
            left: MediaQuery.of(context).size.width * .3,
            top: 17,
            child: Text(
              "Create Item",
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          Positioned(
              right: 0,
              width: 70,
              top: 0,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  if (!isloading) {
                    //  addMenuItem();
                    if (currentModifiers == null) {
                      saveModifiers();
                    } else {
                      updateModifiers();
                    }
                  } else {
                    print("loading...");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    (currentModifiers == null) ? "Save" : "Update",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: utils.getColorFromHex("#878787"),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget MenuItem(Item item) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 15,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "${item.itemName}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
            right: 0,
            top: 10,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      "${utils.localcurrency(item.itemprice)}",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3), fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        foodInModifiers.remove(item);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            child: Container(
              child: Divider(
                height: 1,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showFoodList() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Food List"),
              content: FoodList(),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ));
  }

  Widget FoodList() {
    double height = foodlist.length * 25.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      constraints: BoxConstraints(maxHeight: 300),
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey,
              ),
          padding: EdgeInsets.all(0.0),
          itemCount: foodlist.length,
          itemBuilder: (BuildContext context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  foodInModifiers.add(foodlist.elementAt(index));
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                child: Text(
                  "${foodlist.elementAt(index).itemName}",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                ),
              ))),
    );
  }

  Future<void> getFoodlist() async {
    foodlist = await database.getItems();
    if (foodlist.isEmpty) {
      getFoodlist();
    } else {
      setState(() {});
    }
  }

  Future<void> saveModifiers() {
    setState(() {
      isloading = true;
    });
    FirebaseFirestore.instance.collection("Modifiers").add({
      "modifierName": _modifiersName.text,
      "checkBox": ischeckbox,
      "minimumItem": quantity,
      "last_modified": DateTime.now(),
      "created_date": DateTime.now(),
      "items": List.generate(foodInModifiers.length,
          (index) => foodInModifiers.elementAt(index).itemId)
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Modifiers is successfully added.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: utils.getColorFromHex("#CB0000"),
          textColor: Colors.white,
          fontSize: 16.0);
      /**_menuPriceController.clear();
        _menuNameController.clear();
        _menuPromoController.clear();
        _menuDescription.clear();
        _pickFile=null;
     **/
      emptydetail();
      setState(() {
        isloading = false;
      });
      voidCallback();
    }, onError: (error) {
      print("An error occurred");
      setState(() {
        isloading = false;
      });
    });
  }

  Future<void> updateModifiers() {
    setState(() {
      isloading = true;
    });

    FirebaseFirestore.instance
        .collection("Modifiers")
        .doc(currentModifiers.id)
        .update({
      "modifierName": _modifiersName.text,
      "checkBox": ischeckbox,
      "minimumItem": quantity,
      "last_modified": DateTime.now(),
      "created_date": DateTime.now(),
      "items": List.generate(foodInModifiers.length,
          (index) => foodInModifiers.elementAt(index).itemId)
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Modifiers is successfully added.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: utils.getColorFromHex("#CB0000"),
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isloading = false;
      });
      voidCallback();
    }, onError: (value) {
      print("An error occurred");
      setState(() {
        isloading = false;
      });
    });
  }

  void emptydetail() {
    setState(() {
      foodInModifiers.clear();
      quantity = 0;
      ischeckbox = false;
      _modifiersName.clear();
    });
  }

  Future<void> getFoodInModifiers() async {
    foodInModifiers = await database.getAllItem(currentModifiers.items);

    if (foodInModifiers.isEmpty) {
      getFoodInModifiers();
    } else {
      setState(() {});
    }
  }
}
