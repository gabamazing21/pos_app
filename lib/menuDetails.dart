
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:intl/intl.dart';

import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/Utils/utils.dart';


class menuDetails extends StatefulWidget{


_menuDetailsState createState()=>_menuDetailsState();
}
class _menuDetailsState extends State{

File _pickFile;
Menu item;
bool isloading=false;
String _menuNameError;
String _menuPriceError;
String _menuDescriptionError;
bool isMenuNameError=true;
bool isMenuDescriptionError=true;
bool isMenuCategoryError=true;
bool isMenuPriceError=true;
TextEditingController _menuNameController;
TextEditingController _menuPromoController;
TextEditingController _menuPriceController;
TextEditingController _menuDescription;
bool _iteminedit=false;
bool visibility;
final _picker=ImagePicker();
@override
  void initState() {
    // TODO: implement initState
  _menuDescription=TextEditingController();
  _menuNameController=TextEditingController();
  _menuPromoController=TextEditingController();
  _menuPriceController=TextEditingController();
    super.initState();

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child:

        Column(
          children: [
            getTopToolbar(),

            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 50 - 32,
              child:
              SingleChildScrollView(
                child: Column(
                  children: [
                    getImageValue(),
                    enterMenuDetails(),
                    _selectModifierSet(),
                  ],
                ),
              ),
            ),


          ],

        ),

      ),

    );
  }
  Widget getTopToolbar(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(top: 25),
      child: Stack(

        children: [
          Positioned(
              left: 10,
              top: 15,
              child: 
          GestureDetector(
            onTap: (){


            },
            child: Container(

              child: Icon(Icons.close, size: 30,color: Colors.black,),

            ),
          )),
          Positioned(
           left: MediaQuery.of(context).size.width*.3,
            top: 17,
            child: Text("Create Menu",style: TextStyle(fontSize: 22,color: Colors.black),),
          ),
          Positioned(
            right: 0,
              width: 70,
              top: 0,
              height: 50,
              child: GestureDetector(
                onTap: (){
                 if(!isloading) {
                   addMenu();
                 }else{

                   print("item is loading");
                 }
                },
                child: Container(
                     alignment: Alignment.center,
                  child: Text("Save",style: TextStyle(fontSize: 18,color: Colors.white),),
                decoration: BoxDecoration(

                  color: utils.getColorFromHex("#878787"),

                ),


                ),
              ))
          
        ],
      ),

    );

  }

  Widget getImageValue(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,

      color: utils.getColorFromHex("#F1F1F1"),
      child: Column(
         children: [
           Container(
             width: MediaQuery.of(context).size.width/2,
             height: 150,
             margin: EdgeInsets.only(left: 10,right: 10,top: 10),
             decoration: BoxDecoration(
                 image: DecorationImage(image:(_pickFile==null)?(item==null)?AssetImage('assets/images/placeholder.jpg',):NetworkImage(item.image_link):FileImage(_pickFile),fit: BoxFit.cover ,)

             ),


           ),
           GestureDetector(
             onTap: (){
               pickImage();

             },
             child: Container(
               margin: EdgeInsets.only(top:5),
               alignment: Alignment.center,
               child: Text("Upload Image",style: TextStyle(fontSize: 16,color: Colors.blue,decoration: TextDecoration.underline),),

             ),
           ),


        ],



      ),


    );


  }
Widget enterMenuDetails(){


    return Container(
      width: MediaQuery.of(context).size.width,

      margin: EdgeInsets.only(left: 20,right: 20),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 30,left: 0,right: 0),
            child:  TextFormField(
                keyboardType: TextInputType.text,
                controller: _menuNameController,

                style: TextStyle(

                    color: Colors.black,
                    fontSize: 14
                ),

                onChanged: (text) {

                  if(text.length<2){

                    _menuNameError="Menu Name is required";
                    isMenuNameError=true;
                    print("menu error $isMenuDescriptionError");
                  }else{

                    _menuNameError=null;
                    isMenuNameError=false;
                    print("menu error  $isMenuDescriptionError");
                  }
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                    labelText: "Enter item name",
                    hasFloatingPlaceholder: false,
                    labelStyle: TextStyle(
                        color: utils.getColorFromHex("#979797"),
                        fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                      ,
                      borderSide: BorderSide(color: utils.getColorFromHex(
                          "#979797")),


                    ),
                    errorText: _menuNameError,

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                        ,
                        borderSide: BorderSide(
                            color: utils.getColorFromHex("#CB0000"))

                    )
                    ,
                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: utils.getColorFromHex(
                          "#979797")),

                    )
                )
            ),

          ),


          Visibility(
            visible: true,
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                height: 55,
                //width: 100,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.black.withOpacity(0.2),width: 1),
                    color: Colors.grey.shade100
                ),
                child:
                DropdownButtonHideUnderline(
                  child:
                  DropdownButton(

                    value: "Choose Parent Category",
                    items: <String>["Choose Parent Category","Order Dispatched","Order Delivery"]
                        .map<DropdownMenuItem<String>>((e){
                      return DropdownMenuItem<String>(child: Text(e),
                          value: e);

                    }).toList(), onChanged: (String newvalue){
                    setState(() {

                    });


                  },
                    //elevation: 16,
                    style: TextStyle(color: Colors.black,fontSize: 12),),
                )),
          ),



          Visibility(
            visible: true,
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                height: 55,
                //width: 100,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.black.withOpacity(0.2),width: 1),
                    color: Colors.grey.shade100
                ),
                child:
                DropdownButtonHideUnderline(
                  child:
                  DropdownButton(

                    hint:Text("Select Visibility"),
                    items: <String>["Visible","Invisible"]
                        .map<DropdownMenuItem<String>>((e){
                      return DropdownMenuItem<String>(child: Text(e),
                          value: e);

                    }).toList(), onChanged: (String newvalue){
                    visibility=(newvalue.contains("Visible"))?true:false;
                    setState(() {

                    });


                  },
                    //elevation: 16,
                    style: TextStyle(color: Colors.black,fontSize: 12),),
                )),
          ),


          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width-245,
            child:   Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  margin: EdgeInsets.only(left: 0,right: 5),
                  width: (MediaQuery.of(context).size.width/2)-25-140,
                  child:  TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _menuPriceController,
                      style: TextStyle(

                          color: Colors.black,
                          fontSize: 14
                      ),

                      onChanged: (text) {

                        if(int.parse(text)<=0){
                          _menuPriceError="Price must be greater than 0";
                          isMenuPriceError=true;
                          print("menuPrice $isMenuPriceError");

                        }else{

                          _menuPriceError=null;
                          isMenuPriceError=false;
                          print("menuPrice $isMenuPriceError");
                        }
                        setState(() {

                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Enter normal price"
                          ,
                          hasFloatingPlaceholder: false,
                          labelStyle: TextStyle(
                              color: utils.getColorFromHex("#979797"),
                              fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                            ,
                            borderSide: BorderSide(color: utils.getColorFromHex(
                                "#979797")),


                          ),
                          errorText: _menuPriceError,

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                              ,
                              borderSide: BorderSide(
                                  color: utils.getColorFromHex("#CB0000"))

                          )
                          ,
                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: utils.getColorFromHex(
                                "#979797")),

                          )
                      )
                  ),

                ),
                Container(
                  margin: EdgeInsets.only(left: 0,right: 0),
                  width: (MediaQuery.of(context).size.width/2)-105-25,
                  child:  TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _menuPromoController,
                      style: TextStyle(

                          color: Colors.black,
                          fontSize: 14
                      ),

                      onChanged: (text) {


                      },
                      decoration: InputDecoration(
                          labelText: "Enter promo price"
                          ,
                          hasFloatingPlaceholder: false,
                          labelStyle: TextStyle(
                              color: utils.getColorFromHex("#979797"),
                              fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                            ,
                            borderSide: BorderSide(color: utils.getColorFromHex(
                                "#979797")),


                          ),
                          errorText:null,

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                              ,
                              borderSide: BorderSide(
                                  color: utils.getColorFromHex("#CB0000"))

                          )
                          ,
                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: utils.getColorFromHex(
                                "#979797")),

                          )
                      )
                  ),

                ),
              ],
            ),
          ),

          Visibility(
            visible: false,
            child: Container(
              margin: EdgeInsets.only(top: 10,),
              width: MediaQuery.of(context).size.width,
              child:  TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _menuDescription,
                  style: TextStyle(

                      color: Colors.black,
                      fontSize: 14
                  ),

                  onChanged: (text) {
                    if(text.length<=0){

                      _menuDescriptionError="Menu Description is required";
                      isMenuDescriptionError=true;
                      print("description $isMenuDescriptionError");
                    }else{
                      _menuDescriptionError=null;
                      isMenuDescriptionError=false;
                      print("description $isMenuDescriptionError");

                    }

                    setState(() {

                    });

                  },
                  decoration: InputDecoration(
                      labelText: "Enter Descriptions...."
                      ,
                      hasFloatingPlaceholder: false,
                      labelStyle: TextStyle(
                          color: utils.getColorFromHex("#979797"),
                          fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                        ,
                        borderSide: BorderSide(color: utils.getColorFromHex(
                            "#979797")),


                      ),
                      errorText:_menuDescriptionError,

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                          ,
                          borderSide: BorderSide(
                              color: utils.getColorFromHex("#CB0000"))

                      )
                      ,
                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: utils.getColorFromHex(
                            "#979797")),

                      )
                  )
              ),

            ),
          ),


        ],


      ),

    );





}

Widget _selectModifierSet(){
  return Container(
    width: MediaQuery.of(context).size.width-168,
    margin: EdgeInsets.only(left: 20,right: 20,top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(child: Text("Modifier set",style: TextStyle(fontSize: 16,color: Colors.black,),),),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width-168,
          child: Divider(height: 1.5,color: Colors.black.withOpacity(0.3),),


        ),
       Container(
        constraints: BoxConstraints(maxHeight: 300),
         width: MediaQuery.of(context).size.width-168,
         child: ListView(
           padding: EdgeInsets.all(0.0),
           children: [
             _modifierItem(),
             _modifierItem(),
             _modifierItem(),
             _modifierItem(),
             _modifierItem(),
             _modifierItem(),
             _modifierItem()
           ],

         ),
       )


      ],

    ),



  );



}
Widget _modifierItem(){
  return Container(
    width: MediaQuery.of(context).size.width-168,
    height: 50,
    margin: EdgeInsets.only(top: 10),
    child: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width-168,
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width:(MediaQuery.of(context).size.width-168-60)*.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(

                      margin:EdgeInsets.only(left: 0),
                      child: Text("Modifier 1",style: TextStyle(fontSize: 16,color: Colors.black,),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width-168,
                      height: 20,
                      child: Container(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                            children: [

                              Container(
                                  margin: EdgeInsets.only(right: 2),child: Text("Rice,",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),)),
                              Container(
                                  margin: EdgeInsets.only(right: 2),
                                  child: Text("Bean,",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),)),
                              Container(
                                  margin: EdgeInsets.only(right: 2),
                                  child: Text("Salad",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),))

                            ],

                        ),

                      ),

                    )
                  ],
                ),
              ),

              Container(
                  margin: EdgeInsets.only(),
                  child: Checkbox(value: true, onChanged: (value){

                  },
                    activeColor:utils.getColorFromHex("#CB0000"),
                    checkColor: Colors.white,
                    focusColor:  Colors.black.withOpacity(0.3),
                  )

              )
            ],

          ),


        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Divider(height: 1.5,color: Colors.black.withOpacity(0.3),),


        )




      ],



    ),


  );


}

  Future pickImage()async{

  final _pickedFile=await _picker.getImage(source: ImageSource.gallery,);
  setState(() {
    _pickFile=File(_pickedFile.path);


  });

}


Future<void> addMenu(){

    setState(() {
      isloading=true;

    });

    var date = DateTime.now();
    String filename =path.basename(_pickFile.path) + date.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child(
        "uploads/$filename");
    UploadTask uploadTask = storageReference.putFile(_pickFile);
    TaskSnapshot taskSnapshot = uploadTask.snapshot;
    uploadTask.then((value) {
      value.ref.getDownloadURL().then((value)async {
        print("download link $value");
        FirebaseFirestore.instance.collection("menus").add({

          "menu_images_url": value,
          "menuName":_menuNameController.text,
          "description":_menuDescription.text,
          "price":double.parse(_menuPriceController.text),
          "promo_price":(_menuPromoController.text.isEmpty)?0:_menuPromoController.text,
          "last_modified":DateTime.now(),
          "created_date":DateTime.now(),
          "subMenu":null,
         // "category":_currentCategory.name,
         // "category_id":_currentCategory.documentid,
          "visibility":visibility




        }).then((value) {

          Fluttertoast.showToast(
              msg: "Food Item is  successfully updated.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: utils.getColorFromHex("#CB0000"),
              textColor: Colors.white,
              fontSize: 16.0
          );
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
        });
      }, onError: (value) {
        print("error occurred  $value");


        setState(() {
          isloading = false;
        });
      });
    });




  }





}