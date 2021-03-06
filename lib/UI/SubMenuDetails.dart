import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/modifier.dart';
import 'package:pos_app/Models/submenu.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:path/path.dart' as path;
import 'package:pos_app/component/tool_bar.dart';

class SubMenuDetails extends StatefulWidget {
  submenu currentsubmenu;
  VoidCallback callback;
  SubMenuDetails({this.currentsubmenu, this.callback});

  _SubMenuDetailsState createState() =>
      _SubMenuDetailsState(currentsubmenu: currentsubmenu, callback: callback);
}

class _SubMenuDetailsState extends State {
  File _pickFile;
  String _subMenuNameError;

  bool isloading = false;
  bool isSubmenuError = false;
  submenu item;
  final _picker = ImagePicker();
  List<modifiers> modifiersInSubMenu = List();
  List<modifiers> modifierList = List();
  List<submenu> subMenuInSubMenu = List();
  List<submenu> submenuList = List();
  submenu currentsubmenu;
  bool isimageselected=false;

  _SubMenuDetailsState({this.currentsubmenu, this.callback});

  TextEditingController _subMenuController = TextEditingController();
  VoidCallback callback;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (currentsubmenu != null) {
      _subMenuController.text = currentsubmenu.submenuname;
      isSubmenuError=false;
      isimageselected=true;
      if (currentsubmenu.subMenu != null) getSubmenuList();
      getModfierList();
    }
    getSubMenu();
    getModifierList();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ToolBar(
              callback: callback,
              title: currentsubmenu == null ? "Create SubMenu" : "Edit SubMenu",
            ),
            Flexible(
              child:
                  SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          getImageValue(),
                          enterMenuDetails(),
                          //_selectModifierSet(),
                          Container(
                            margin: EdgeInsets.only(top: 0, left: 20),
                            child: Text(
                              "Modifiers",
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
                            height: 50.0 * modifiersInSubMenu.length,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height - 503 - 142),
                            child: ListView.builder(
                              itemCount: modifiersInSubMenu.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  MenuItem(modifiersInSubMenu.elementAt(index)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModifierList();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                "Add Modifiers",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.5)),
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
                            margin: EdgeInsets.only(top: 0, left: 20),
                            child: Text(
                              "Submenu",
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
                            height: 50.0 * subMenuInSubMenu.length,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height - 503 - 142),
                            child: ListView.builder(
                              itemCount: subMenuInSubMenu.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  subMenuItem(subMenuInSubMenu.elementAt(index)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showsubMenuList();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                "Add Submenu",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.5)),
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
                            color:(!isSubmenuError && modifiersInSubMenu.isNotEmpty &&  isimageselected)? Colors.red:Colors.red.withOpacity(0.3),
                            child: FlatButton(
                              onPressed: () {
                                if ((!isSubmenuError &&
                                    modifiersInSubMenu.isNotEmpty &&
                                    isimageselected)) {
                                  if (!isloading) {
                                    if (currentsubmenu == null) {
                                      addSubmenu();
                                    } else {
                                      updateSubmenu();
                                    }
                                  } else {
                                    print("loading...");
                                  }
                                }
                              },
                              child:(!isloading) ?Text(
                                currentsubmenu == null ? "Save" : "Update",
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
            ));

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
                  setState(() {});
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
                    if (currentsubmenu == null) {
                      addSubmenu();
                    } else {
                      updateSubmenu();
                    }
                  } else {
                    print("loading...");
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Save",
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

  Widget getImageValue() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: (_pickFile == null)
                  ? (item == null)
                      ? AssetImage(
                          'assets/images/placeholder.jpg',
                        )
                      : NetworkImage(item.imagelink)
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
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 30, left: 0, right: 0),
            child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _subMenuController,
                style: TextStyle(color: Colors.black, fontSize: 14),
                onChanged: (text) {
                  if (text.length < 2) {
                    _subMenuNameError = "Menu Name is required";
                    isSubmenuError = true;
                    print("menu error");
                  } else {
                    _subMenuNameError = null;
                    isSubmenuError = false;
                    print("menu error");
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
                    errorText: _subMenuNameError,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: utils.getColorFromHex("#CB0000"))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: utils.getColorFromHex("#979797")),
                    ))),
          )
        ]));
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

  Widget MenuItem(modifiers item) {
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
                        "${item.modifier_name}",
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        modifiersInSubMenu.remove(item);
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

  Widget subMenuItem(submenu item) {
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
                        "${item.submenuname}",
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        subMenuInSubMenu.remove(item);
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

  void showModifierList() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Modifiers List"),
              content: ModifiersList(),
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

  void showsubMenuList() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("SubMenu List"),
              content: SubMenuList(),
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

  Widget ModifiersList() {

    double height =(modifierList!=null)? modifierList.length * 25.0:50;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      constraints: BoxConstraints(maxHeight: 300),
      child:(modifierList!=null)? ListView.separated(
          separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey,
              ),
          padding: EdgeInsets.all(0.0),
          itemCount: modifierList.length,
          itemBuilder: (BuildContext context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  modifiersInSubMenu.add(modifierList.elementAt(index));
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                child: Text(
                  "${modifierList.elementAt(index).modifier_name}",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                ),
              ))):Container(

        width: MediaQuery.of(context).size.width,
    height: 30,
    child: Text("No modifier available",style: TextStyle(fontSize: 15,color: Colors.black),),));
  }

  Widget SubMenuList() {

    double height =(submenuList!=null) ?submenuList.length * 25.0:50;

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

                  subMenuInSubMenu.add(submenuList.elementAt(index));
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

  Future<void> getSubMenu() async {
    submenuList = await database.getAllSubMenu();
    if(submenuList!=null) {
      if (submenuList.isEmpty) {
        getSubMenu();
      } else {
        if (currentsubmenu != null) {
          print("current menu is not empty");
          submenuList.forEach((element) {
            if (element.submeuid.contains(currentsubmenu.submeuid)) {
              submenuList.remove(element);
            }
          });
        }
        setState(() {});
      }
    }else{
      setState(() {

      });

    }
  }

  Future<void> getModifierList() async {
    modifierList = await database.getAllModifier();
    if (modifierList.isEmpty) {
      getModifierList();
    } else {
      setState(() {});
    }
  }

  Future<void> addSubmenu() async {
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
        FirebaseFirestore.instance.collection("subMenu").add({
          "imageUrl": value,
          "title": _subMenuController.text,
          "last_modified": DateTime.now(),
          "created_date": DateTime.now(),
          "subMenu": (subMenuInSubMenu.isEmpty)
              ? null
              : List.generate(subMenuInSubMenu.length,
                  (index) => subMenuInSubMenu.elementAt(index).submeuid),
          "modifiers": List.generate(modifiersInSubMenu.length,
              (index) => modifiersInSubMenu.elementAt(index).id)
        });
        // "category":_currentCategory.name,
        // "category_id":_currentCategory.documentid,
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Food Item is  successfully updated.",
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
              _subMenuController.clear();
        _pickFile=null;

        setState(() {
          isloading = false;
        });
        callback();
      }, onError: (error) {
        print("An error occurred");
        setState(() {
          isloading = false;
        });
        Fluttertoast.showToast(
            msg: "Unable to add SubMenu.",
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
          msg: "Unable to add SubMenu.",
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
  }

  Future<void> getSubmenuList() async {

    subMenuInSubMenu = await database.getAllSubMenuList(currentsubmenu.subMenu);
    if(subMenuInSubMenu!=null) {
      if (subMenuInSubMenu.isEmpty) {
        getSubmenuList();
      } else {
        setState(() {});
      }
    }else{


    }
  }

  Future<void> getModfierList() async {
    modifiersInSubMenu =
        await database.getAllModifierList(currentsubmenu.modifiers);
    if (modifiersInSubMenu.isEmpty) {
      getModifierList();
    } else {
      setState(() {});
    }
  }

  Future<void> updateSubmenu() {
    setState(() {
      isloading=true;
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
              .collection("subMenu")
              .doc(currentsubmenu.submeuid)
              .update({
            "imageUrl": value,
            "title": _subMenuController.text,
            "last_modified": DateTime.now(),
            "subMenu": (subMenuInSubMenu.isEmpty)
                ? null
                : List.generate(subMenuInSubMenu.length,
                    (index) => subMenuInSubMenu.elementAt(index).submeuid),
            "modifiers": List.generate(modifiersInSubMenu.length,
                (index) => modifiersInSubMenu.elementAt(index).id)
          });
          // "category":_currentCategory.name,
          // "category_id":_currentCategory.documentid,
        }).then((value) {
          Fluttertoast.showToast(
              msg: "SubMenu  is  successfully updated.",
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
          _subMenuController.clear();
          _pickFile=null;
          setState(() {
            isloading = false;
          });
       callback();
        }, onError: (error) {
          print("An error occurred");
          setState(() {
            isloading = false;

          });
          Fluttertoast.showToast(
              msg: "SubMenu  is  unable to updated.",
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
            msg: "Submenu is unable to save try again..",
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
    } else {
      FirebaseFirestore.instance
          .collection("subMenu")
          .doc(currentsubmenu.submeuid)
          .update({
        "title": _subMenuController.text,
        "last_modified": DateTime.now(),
        "subMenu": (subMenuInSubMenu.isEmpty)
            ? null
            : List.generate(subMenuInSubMenu.length,
                (index) => subMenuInSubMenu.elementAt(index).submeuid),
        "modifiers": List.generate(modifiersInSubMenu.length,
            (index) => modifiersInSubMenu.elementAt(index).id)
      }).then((value) {
        Fluttertoast.showToast(
            msg: "SubMenu  is  successfully updated.",
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
        _subMenuController.clear();
        _pickFile=null;
        setState(() {
          isloading = false;
        });
        callback();
      });
    }
  }
}
