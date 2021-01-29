import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:intl/intl.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/Item.dart';

import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/Models/submenu.dart';
import 'package:pos_app/Utils/utils.dart';

class menuDetails extends StatefulWidget {
  String id;

  menuDetails(this.id);

  _menuDetailsState createState() => _menuDetailsState(id);
}

class _menuDetailsState extends State {
  File _pickFile;
  Menu currentMenu;
  String id;
  List<submenu> submenuList;
  List<submenu> subMenuInMenu = List();
  List<Item> _itemList = List();
  bool isloading = false;
  bool isloadingitem = true;
  String _menuNameError;
  String _menuPriceError;
  String _menuDescriptionError;
  bool isMenuNameError = false;
  bool isimageSeleted=false;
  bool isMenuDescriptionError = true;
  bool isMenuCategoryError = true;
  bool isMenuPriceError = true;

  TextEditingController _menuNameController;
  TextEditingController _menuPromoController;
  TextEditingController _menuPriceController;
  TextEditingController _menuDescription;
  bool _iteminedit = false;
  bool visibility = true;
  List<String> selectedSubmnu = List();
  final _picker = ImagePicker();

  _menuDetailsState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    _menuDescription = TextEditingController();
    _menuNameController = TextEditingController();
    _menuPromoController = TextEditingController();
    _menuPriceController = TextEditingController();
    if (id != null) {
      getMenuDetail();
      isMenuNameError=true;
      isimageSeleted=true;
      print("value id is not null");
    }
    getSubmenuList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text((currentMenu == null)
            ? "Create Menu"
            : currentMenu.menu_name + " Details"),
        backgroundColor: utils.getColorFromHex("#3D3D3D"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              // width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height - 7 - 81,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    getImageValue(),
                    enterMenuDetails(),
                    _selectModifierSet(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      color:(!isMenuNameError && isimageSeleted&& subMenuInMenu.isNotEmpty) ?utils.getColorFromHex("#CC1313"):utils.getColorFromHex("#CC1313").withOpacity(0.3),
                      child: FlatButton(
                        onPressed: () {
                          if (!isMenuNameError && isimageSeleted && subMenuInMenu.isNotEmpty) {
                            if (!isloading) {
                              if (id == null) {
                                addMenu();
                              } else {
                                updateDetails();
                              }
                            } else {
                              print("item is loading");
                            }
                          }
                        },
                        child:(!isloading) ?Text(
                          (currentMenu == null) ? "Save" : "Update",
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
                onTap: () {},
                child: Container(
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              )),
          Positioned(
            left: MediaQuery.of(context).size.width * .3,
            top: 17,
            child: Text(
              "Create Menu",
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
                    if (id == null) {
                      addMenu();
                    } else {
                      updateDetails();
                    }
                  } else {
                    print("item is loading");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: (!isloading)
                      ? Text(
                          (currentMenu == null) ? "Save" : "Update",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            value: null,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )),
                  decoration: BoxDecoration(
                    color: utils.getColorFromHex("#878787"),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget getImageValue() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      height: 200,
      // color: utils.getColorFromHex("#F1F1F1"),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: (_pickFile == null)
                  ? (currentMenu == null)
                      ? AssetImage(
                          'assets/images/placeholder.jpg',
                        )
                      : NetworkImage(currentMenu.image_link)
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
          // Container(
          //   margin: EdgeInsets.only(top: 10),
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //         margin: EdgeInsets.only(left: 0, right: 5),
          //         width: (MediaQuery.of(context).size.width * 0.35),
          //         child: TextFormField(
          //             keyboardType: TextInputType.number,
          //             controller: _menuPriceController,
          //             style: TextStyle(color: Colors.black, fontSize: 14),
          //             onChanged: (text) {
          //               if (int.parse(text) <= 0) {
          //                 _menuPriceError = "Price must be greater than 0";
          //                 isMenuPriceError = true;
          //                 print("menuPrice $isMenuPriceError");
          //               } else {
          //                 _menuPriceError = null;
          //                 isMenuPriceError = false;
          //                 print("menuPrice $isMenuPriceError");
          //               }
          //               setState(() {});
          //             },
          //             decoration: InputDecoration(
          //                 labelText: "Enter normal price",
          //                 hasFloatingPlaceholder: false,
          //                 labelStyle: TextStyle(
          //                     color: utils.getColorFromHex("#979797"),
          //                     fontSize: 14),
          //                 enabledBorder: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(5),
          //                   borderSide: BorderSide(
          //                       color: utils.getColorFromHex("#979797")),
          //                 ),
          //                 errorText: _menuPriceError,
          //                 focusedBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(5),
          //                     borderSide: BorderSide(
          //                         color: utils.getColorFromHex("#CB0000"))),
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(5),
          //                   borderSide: BorderSide(
          //                       color: utils.getColorFromHex("#979797")),
          //                 ))),
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(left: 0, right: 0),
          //         width: (MediaQuery.of(context).size.width * 0.37),
          //         child: TextFormField(
          //             keyboardType: TextInputType.text,
          //             controller: _menuPromoController,
          //             style: TextStyle(color: Colors.black, fontSize: 14),
          //             onChanged: (text) {},
          //             decoration: InputDecoration(
          //                 labelText: "Enter promo price",
          //                 hasFloatingPlaceholder: false,
          //                 labelStyle: TextStyle(
          //                     color: utils.getColorFromHex("#979797"),
          //                     fontSize: 14),
          //                 enabledBorder: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(5),
          //                   borderSide: BorderSide(
          //                       color: utils.getColorFromHex("#979797")),
          //                 ),
          //                 errorText: null,
          //                 focusedBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(5),
          //                     borderSide: BorderSide(
          //                         color: utils.getColorFromHex("#CB0000"))),
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(5),
          //                   borderSide: BorderSide(
          //                       color: utils.getColorFromHex("#979797")),
          //                 ))),
          //       ),
          //     ],
          //   ),
          // ),
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
                      _menuDescriptionError = "Menu Description is required";
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
        ],
      ),
    );
  }

  Widget _selectModifierSet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "SubMenu",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            child: Divider(
              height: 1.5,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0 * subMenuInMenu.length,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 503 - 142),
            child: ListView.builder(
              itemCount: subMenuInMenu.length,
              itemBuilder: (BuildContext context, int index) =>
                  _subMenuItem(subMenuInMenu.elementAt(index)),
            ),
          ),
          GestureDetector(
            onTap: () {
              //showFoodList();
              showSubMenuDetails();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Add SubMenu",
                style: TextStyle(
                    fontSize: 16, color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subMenuItem(submenu item) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width) * .7,
                  // width:MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0),
                        child: Text(
                          item.submenuname,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          //width: MediaQuery.of(context).size.width-168,
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(right: 2),
                                    child: Text(
                                      "Rice,",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(0.6)),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(right: 2),
                                    child: Text(
                                      "Bean,",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(0.6)),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(right: 2),
                                    child: Text(
                                      "Salad",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(0.6)),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      subMenuInMenu.remove(item);
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
          Container(
            width: MediaQuery.of(context).size.width,
            child: Divider(
              height: 1.5,
              color: Colors.black.withOpacity(0.3),
            ),
          )
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

        isimageSeleted=true;
      }else{

        isimageSeleted=false;
      }
    });
  }

  Future<void> addMenu() {
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
        FirebaseFirestore.instance.collection("menus").add({
          "imageLink": value,
          "menuName": _menuNameController.text,
          // "description": _menuDescription.text,
          // "price": double.parse(_menuPriceController.text),
          // "promo_price": (_menuPromoController.text.isEmpty)
          //     ? 0
          //     : _menuPromoController.text,
          "last_modified": DateTime.now(),
          "created_date": DateTime.now(),
          "subMenu": List.generate(subMenuInMenu.length, (index) => subMenuInMenu.elementAt(index).submeuid),
          // "category":_currentCategory.name,
          // "category_id":_currentCategory.documentid,
          "visibility": visibility
        }).then((value) {
          Fluttertoast.showToast(
              msg: "Menu  Item is  successfully updated.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: utils.getColorFromHex("#CB0000"),
              textColor: Colors.white,
              fontSize: 16.0);

              _menuNameController.clear();
               subMenuInMenu.clear();
              _pickFile=null;


          setState(() {
            isloading = false;
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

  Future<void> getSubmenuList() async {
    submenuList = await database.getAllSubMenu();
    if (submenuList != null) {
      if (submenuList.isEmpty) {
        getSubmenuList();
      } else {
        setState(() {});
      }
    }
  }

  Future<void> getSubMenu() async {
    subMenuInMenu = await database.getAllSubMenuList(currentMenu.sub_menu);
    if (subMenuInMenu.isEmpty) {
      getSubMenu();
    } else {
      setState(() {});
    }
  }

  void showSubMenuDetails() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Sub Menu"),
              content: subMenuList(),
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

  Widget subMenuList() {
    double height =(submenuList!=null)? submenuList.length * 25.0:50;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      constraints: BoxConstraints(maxHeight: 300),
      child:(submenuList!=null)? ListView.separated(
          separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey,
              ),
          padding: EdgeInsets.all(0.0),
          itemCount: submenuList.length,
          itemBuilder: (BuildContext context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  subMenuInMenu.add(submenuList.elementAt(index));
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                child: Text(
                  "${submenuList.elementAt(index).submenuname}",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                ),
              ))):Container(

        width: MediaQuery.of(context).size.width,
    height: 30,
    child: Text("No submenu available",style: TextStyle(fontSize: 15,color: Colors.black),),));
  }

  Future<void> getMenuDetail() async {
    print("$id getting value for menuDetails");
    currentMenu = await database.getMenuItem(id);
    if (currentMenu == null) {
      getMenuDetail();
    } else {
      if (currentMenu != null) {
        print("${currentMenu.menu_name} is not null");
        _menuDescription.text = currentMenu.decription;
        _menuNameController.text = currentMenu.menu_name;
        _menuPromoController.text = currentMenu.promoprice;
        _menuPriceController.text = currentMenu.price;
        getSubMenu();
      }
      setState(() {});
    }
  }

  Future<void> updateDetails() async {
    if (_pickFile != null) {
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
          FirebaseFirestore.instance.collection("menus").doc(id).update({
            "imageLink": value,
            "menuName": _menuNameController.text,
            "description": _menuDescription.text,
            "price": double.parse(_menuPriceController.text),
            "promo_price": (_menuPromoController.text.isEmpty)
                ? 0
                : _menuPromoController.text,
            "last_modified": DateTime.now(),

            "subMenu": (subMenuInMenu.isNotEmpty)
                ? List.generate(subMenuInMenu.length,
                    (index) => subMenuInMenu.elementAt(index).submeuid)
                : null,
            // "category":_currentCategory.name,
            // "category_id":_currentCategory.documentid,
            "visibility": visibility
          }).then((value) {
            Fluttertoast.showToast(
                msg: "Menu is   updated successfully.",
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

            setState(() {
              isloading = false;
            });
          }, onError: (error) {
            print("An error occurred");
            setState(() {
              isloading = false;
            });
            Fluttertoast.showToast(
                msg: "Unable to add Menu.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: utils.getColorFromHex("#CB0000"),
                textColor: Colors.white,
                fontSize: 16.0);
          });
        }, onError: (value) {
          print("error occurred  $value");
          Fluttertoast.showToast(
              msg: "Unable to add Menu.",
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
      });
    } else {
      print("updating item only");
      FirebaseFirestore.instance.collection("menus").doc(id).update({
        "menuName": _menuNameController.text,
        "description": _menuDescription.text,
        "price": double.parse(_menuPriceController.text),
        "promo_price":
            (_menuPromoController.text.isEmpty) ? 0 : _menuPromoController.text,
        "last_modified": DateTime.now(),

        "subMenu": (subMenuInMenu.isNotEmpty)
            ? List.generate(subMenuInMenu.length,
                (index) => subMenuInMenu.elementAt(index).submeuid)
            : null,
        // "category":_currentCategory.name,
        // "category_id":_currentCategory.documentid,
        "visibility": visibility
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Menu is   updated successfully.",
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

        setState(() {
          isloading = false;
        });
      }, onError: (value) {
        setState(() {
          isloading = false;
        });
        Fluttertoast.showToast(
            msg: "Unable to update Menu.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: utils.getColorFromHex("#CB0000"),
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }
}
