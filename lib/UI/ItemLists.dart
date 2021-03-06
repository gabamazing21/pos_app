import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/Item.dart';
import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:path/path.dart' as path;
import 'package:pos_app/component/tool_bar.dart';

class ItemList extends StatefulWidget {
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State {
  File _pickFile;
  Item item = null;
  bool noItemAvailable = false;
  TextEditingController _searchController = TextEditingController();
  String _menuNameError;
  String _menuPriceError;
  String _menuDescriptionError;
  bool isMenuNameError = true;
  bool isMenuDescriptionError = true;
  bool isMenuCategoryError = true;
  bool isMenuPriceError = true;
  bool visibility = true;
  bool isimageselected=false;
  bool isloading = false;
  List<Item> _itemList = List();
  final _picker = ImagePicker();
  TextEditingController _menuNameController;
  TextEditingController _menuPromoController;
  TextEditingController _menuPriceController;
  TextEditingController _menuDescription;
  bool addItem = false;
  bool isitemloading = true;

  @override
  void initState() {
//
    _menuDescription = TextEditingController();
    _menuNameController = TextEditingController();
    _menuPromoController = TextEditingController();
    _menuPriceController = TextEditingController();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return (!addItem)
        ? Scaffold(
            appBar: AppBar(
              title: Text("All Item",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
              backgroundColor: utils.getColorFromHex("#F1F1F1"),
            ),
            body: SingleChildScrollView(
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
                          labelText: "Search Item",
                          suffixIcon: Icon(
                            Icons.search,
                            size: 25,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            addItem = true;
                          });
                        },
                        child: Text(
                          "Add Item",
                          style: TextStyle(
                              fontSize: 16,
                              color: utils.getColorFromHex("#0D97FF")),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 210,
                      child: (!isitemloading)
                          ? (!noItemAvailable)
                              ? ListView.builder(
                                  itemCount: _itemList.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      GestureDetector(
                                          onTap: () {
                                            item = _itemList.elementAt(index);
                                            addItem = true;
                                            setState(() {});
                                          },
                                          child: _orderItem(
                                              _itemList.elementAt(index))),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No Item yet",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                          : Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                value: null,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    utils.getColorFromHex("#CC1313")),
                              )),
                    )
                  ],
                ),
              ),
            ),
          )
        : showAddItem();
  }

  Widget _orderItem(Item item) {
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
                child: Image.network(
                  "${item.imageLink}",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
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
                    "${item.itemName}",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              )),
          Positioned(
              top: 10,
              right: 10,
              child: Text(
                "${utils.localcurrency(item.itemprice)}",
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

  Widget showAddItem() {
    if(item!=null){
      isMenuPriceError=false;
      isMenuNameError=false;
      isimageselected=true;

    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ToolBar(
              callback: () {
                setState(() {
                  addItem = false;
                  _menuNameController.clear();
                  _menuPriceController.clear();
                  _pickFile=null;
                });
              },
              title: (item == null) ? 'Create Item' : 'Edit Item',
            ),
            Flexible(
//            width: MediaQuery.of(context).size.width,
//            height: MediaQuery.of(context).size.height - 50 - 26,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    getImageValue(),
                    enterMenuDetails(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      color:(!isMenuNameError && !isMenuPriceError && isimageselected)? Colors.red:Colors.red.withOpacity(0.3),
                      child: FlatButton(
                        onPressed: () {
                          if ((!isMenuNameError && !isMenuPriceError &&
                              isimageselected)) {
                            if (!isloading) {
                              if (item == null) {
                                addMenuItem();
                              } else {
                                updateItem();
                              }
                            } else {
                              print("loading...");
                            }
                          }
                        },
                        child: (!isloading)?Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ):Container(

                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: null,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),


                            )),
                      ),
                    )
                  ],
                ),
              ),
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
                    addItem = false;
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
                    if (item == null) {
                      addMenuItem();
                    } else {
                      updateItem();
                    }
                  } else {
                    print("loading...");
                  }
                },
                child:(!isloading)? Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: utils.getColorFromHex("#878787"),
                  ),
                ):Container(

                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: null,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),


                    )),
              ))
        ],
      ),
    );
  }

  Widget getImageValue() {
    return Container(
      width: 200,
      height: 200,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 150,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: (_pickFile == null)
                  ? (item == null)
                      ? AssetImage(
                          'assets/images/placeholder.jpg',
                        )
                      : NetworkImage(item.imageLink)
                  : FileImage(_pickFile),
              fit: BoxFit.cover,
            )),
          ),
          GestureDetector(
            onTap: () {
              pickImage();
            },
            child: Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              child: Text(
                "Upload Image",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget enterMenuDetails() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 30, left: 0, right: 0),
            child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _menuNameController,
                style: TextStyle(color: Colors.black, fontSize: 14),
                onChanged: (text) {
                  if (text.length < 2) {
                    _menuNameError = "Menu Name is required";
                    isMenuNameError = true;
                    print("menu error $isMenuDescriptionError");
                  } else {
                    _menuNameError = null;
                    isMenuNameError = false;
                    print("menu error  $isMenuDescriptionError");
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Enter item name",
                    hasFloatingPlaceholder: false,
                    labelStyle: TextStyle(
                        color: utils.getColorFromHex("#979797"), fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: utils.getColorFromHex("#979797")),
                    ),
                    errorText: _menuNameError,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: utils.getColorFromHex("#CB0000"))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: utils.getColorFromHex("#979797")),
                    ))),
          ),
          Visibility(
            visible: false,
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                height: 55,
                //width: 100,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: Colors.black.withOpacity(0.2), width: 1),
                    color: Colors.grey.shade100),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: "Choose Parent Category",
                    items: <String>[
                      "Choose Parent Category",
                      "Order Dispatched",
                      "Order Delivery"
                    ].map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(child: Text(e), value: e);
                    }).toList(),
                    onChanged: (String newvalue) {
                      setState(() {});
                    },
                    //elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                )),
          ),
          Visibility(
            visible: false,
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                height: 55,
                //width: 100,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: Colors.black.withOpacity(0.2), width: 1),
                    color: Colors.grey.shade100),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text("Select Visibility"),
                    items: <String>["Visible", "Invisible"]
                        .map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(child: Text(e), value: e);
                    }).toList(),
                    onChanged: (String newvalue) {
                      visibility =
                          (newvalue.contains("Visible")) ? true : false;
                      setState(() {});
                    },
                    //elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width - 245,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0, right: 5),
                  width: (MediaQuery.of(context).size.width / 2) - 25 - 140,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _menuPriceController,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      onChanged: (text) {
                        if (int.parse(text) <= 0) {
                          _menuPriceError = "Price must be greater than 0";
                          isMenuPriceError = true;
                          print("menuPrice $isMenuPriceError");
                        } else {
                          _menuPriceError = null;
                          isMenuPriceError = false;
                          print("menuPrice $isMenuPriceError");
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          labelText: "Enter normal price",
                          hasFloatingPlaceholder: false,
                          labelStyle: TextStyle(
                              color: utils.getColorFromHex("#979797"),
                              fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: utils.getColorFromHex("#979797")),
                          ),
                          errorText: _menuPriceError,
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
                Container(
                  margin: EdgeInsets.only(left: 0, right: 0),
                  width: (MediaQuery.of(context).size.width / 2) - 105 - 25,
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _menuPromoController,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      onChanged: (text) {},
                      decoration: InputDecoration(
                          labelText: "Enter promo price",
                          hasFloatingPlaceholder: false,
                          labelStyle: TextStyle(
                              color: utils.getColorFromHex("#979797"),
                              fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: utils.getColorFromHex("#979797")),
                          ),
                          errorText: null,
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
              ],
            ),
          ),
          Visibility(
            visible: false,
            child: Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _menuDescription,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  onChanged: (text) {
                    if (text.length <= 0) {
                      _menuDescriptionError = "Item Description is required";
                      isMenuDescriptionError = true;
                      print("description $isMenuDescriptionError");
                    } else {
                      _menuDescriptionError = null;
                      isMenuDescriptionError = false;
                      print("description $isMenuDescriptionError");
                    }

                    setState(() {});
                  },
                  decoration: InputDecoration(
                      labelText: "Enter Descriptions....",
                      hasFloatingPlaceholder: false,
                      labelStyle: TextStyle(
                          color: utils.getColorFromHex("#979797"),
                          fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: utils.getColorFromHex("#979797")),
                      ),
                      errorText: _menuDescriptionError,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: utils.getColorFromHex("#CB0000"))),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: utils.getColorFromHex("#979797")),
                      ))),
            ),
          ),
          Visibility(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 0,
                  child: Text(
                    "Visibility",
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
                      value: visibility,
                      onChanged: (vale) {
                        setState(() {
                          visibility = vale;
                        });
                      },
                      activeColor: utils.getColorFromHex("#CB0000"),
                      checkColor: Colors.white,
                      focusColor: Colors.black.withOpacity(0.3),
                    ))
              ],
            ),
          )),
        ],
      ),
    );
  }

  Future pickImage() async {
    final _pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _pickFile = File(_pickedFile.path);
      if(_pickFile!=null){

        isimageselected=true;
      }else{
        isimageselected=false;

      }
    });
  }

  Future<void> addMenuItem() {
    if(_pickFile==null){
      Fluttertoast.showToast(
          msg: "No Image Selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: utils.getColorFromHex("#CB0000"),
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
    setState(() {
      isloading = true;
    });

    var date = DateTime.now();
    String filename = path.basename(_pickFile.path) + date.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("uploads/$filename");
    UploadTask uploadTask = storageReference.putFile(_pickFile);
    TaskSnapshot taskSnapshot = uploadTask.snapshot;
    uploadTask.then((value) {
      value.ref.getDownloadURL().then((value) async {
        print("download link $value");
        FirebaseFirestore.instance.collection("Items").add({
          "imageLink": value,
          "itemName": _menuNameController.text,
          "description": _menuDescription.text,
          "ItemPrice": double.parse(_menuPriceController.text),
          "promo_price": (_menuPromoController.text.isEmpty)
              ? 0
              : _menuPromoController.text,
          "last_modified": DateTime.now(),
          "created_date": DateTime.now(),

          // "category":_currentCategory.name,
          // "category_id":_currentCategory.documentid,
          "visible": visibility
        }).then((value) {
          Fluttertoast.showToast(
              msg: "Food Item is  successfully updated.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: utils.getColorFromHex("#CB0000"),
              textColor: Colors.white,
              fontSize: 16.0);
          _menuPriceController.clear();
              _menuNameController.clear();
              _menuPromoController.clear();
              _menuDescription.clear();
              _pickFile=null;


          setState(() {
            isloading = false;
            addItem = false;
          });
        }, onError: (error) {
          print("An error occurred");
          setState(() {
            isloading = false;
          });
        });
      }, onError: (value) {
        print("error occurred  $value");

        setState(() {
          isloading = false;
        });
      });
    });
  }

  Future<void> updateItem() async {
    setState(() {
      isloading = true;
    });
    if (_pickFile != null) {
      var date = DateTime.now();
      String filename = path.basename(_pickFile.path) + date.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child("uploads/$filename");
      UploadTask uploadTask = storageReference.putFile(_pickFile);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      uploadTask.then((value) {
        value.ref.getDownloadURL().then((value) async {
          print("download link $value");
          FirebaseFirestore.instance
              .collection("Items")
              .doc(item.itemId)
              .update({
            "imageLink": value,
            "itemName": _menuNameController.text,
            "description": _menuDescription.text,
            "ItemPrice": double.parse(_menuPriceController.text),
            "promo_price": (_menuPromoController.text.isEmpty)
                ? 0
                : _menuPromoController.text,
            "last_modified": DateTime.now(),


            // "category":_currentCategory.name,
            // "category_id":_currentCategory.documentid,
            "visible": visibility
          }).then((value) {
            Fluttertoast.showToast(
                msg: "Food Item is  successfully updated.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: utils.getColorFromHex("#CB0000"),
                textColor: Colors.white,
                fontSize: 16.0);
            _menuPriceController.clear();
                _menuNameController.clear();
                _menuPromoController.clear();
                _menuDescription.clear();
                _pickFile=null;


            setState(() {
              isloading = false;
              addItem = false;
            });

          }, onError: (error) {
            print("An error occurred");
            Fluttertoast.showToast(
                msg: "Unable to add  food item.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: utils.getColorFromHex("#CB0000"),
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {
              isloading = false;
            });
          });
        }, onError: (value) {
          print("error occurred  $value");

          setState(() {
            isloading = false;
          });
        });
      });
    } else {
      FirebaseFirestore.instance.collection("Items").doc(item.itemId).update({
        "itemName": _menuNameController.text,
        "description": _menuDescription.text,
        "ItemPrice": double.parse(_menuPriceController.text),
        "promo_price":
            (_menuPromoController.text.isEmpty) ? 0 : _menuPromoController.text,
        "last_modified": DateTime.now(),


        // "category":_currentCategory.name,
        // "category_id":_currentCategory.documentid,
        "visible": visibility
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Food Item is  successfully updated.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: utils.getColorFromHex("#CB0000"),
            textColor: Colors.white,
            fontSize: 16.0);
        _menuPriceController.clear();
            _menuNameController.clear();
            _menuPromoController.clear();
            _menuDescription.clear();
            _pickFile=null;


        setState(() {
          isloading = false;
          addItem = false;
        });
      });
    }
  }
  //gotvnigeria@multichoice.co.za

  Future<void> getItems() async {
    _itemList = await database.getItems();
    if (_itemList != null) {
      if (_itemList.isEmpty) {
        getItems();
      } else {
        isitemloading = false;
        noItemAvailable = false;
        setState(() {});
      }
    } else {
      isitemloading = false;
      noItemAvailable = true;
      setState(() {});
    }
  }
}
