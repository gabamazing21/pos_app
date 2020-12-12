import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/Utils/utils.dart';

class ItemList extends StatefulWidget{

_ItemListState createState()=> _ItemListState();

}
class _ItemListState extends State{
  File _pickFile;
Menu item=null;
TextEditingController _searchController=TextEditingController();
String _menuNameError;
String _menuPriceError;
String _menuDescriptionError;
bool isMenuNameError=true;
bool isMenuDescriptionError=true;
bool isMenuCategoryError=true;
bool isMenuPriceError=true;
bool visibility;
  final _picker=ImagePicker();
TextEditingController _menuNameController;
TextEditingController _menuPromoController;
TextEditingController _menuPriceController;
TextEditingController _menuDescription;
bool addItem=false;

@override
  void initState() {
//
  _menuDescription=TextEditingController();
  _menuNameController=TextEditingController();
  _menuPromoController=TextEditingController();
  _menuPriceController=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(

  appBar: AppBar(title: Text("All Item",style: TextStyle(fontSize: 16,color: Colors.black,)),backgroundColor: utils.getColorFromHex("#F1F1F1"),),

body:(!addItem) ?Container(
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
          style: TextStyle(fontSize: 16,color: Colors.black,),
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Search Item",
            suffixIcon: Icon(Icons.search,size: 25,),
            border: InputBorder.none,

          ),


        ),
      ),

      Container(
        margin: EdgeInsets.only(top: 30,left: 20,right: 20),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: FlatButton(
          onPressed: (){
            setState(() {
              addItem=true;

            });

          },
          child: Text("Add Item",style: TextStyle(fontSize: 16,color: utils.getColorFromHex("#0D97FF")),),),

        
      ),

      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-210,
        child: ListView.builder(

          itemCount: 10,
          itemBuilder: (BuildContext context,int index)=>_orderItem(),
        ),
      )

    ],

  ),


):showAddItem(),
);

  }

Widget _orderItem(){

  return Container(
    width: MediaQuery.of(context).size.width,
    height: 60,
    margin: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
    child: Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          child: Container(width: 50,height: 50,
              child:Image.asset("assets/images/fast_food.jpg",height: 50,width: 50,fit: BoxFit.cover,)),
        ),
        Positioned(
            top: 5,
            left: 70,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SEVERE",style: TextStyle(fontSize: 25,color: Colors.black),),

              ],

            )),
        Positioned(
            top: 10,
            right: 10,
            child: Text("${utils.localcurrency(2.0)}",style: TextStyle(fontSize: 18,color: Colors.black.withOpacity(0.5)),)),

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
Widget showAddItem(){
return Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height-300,
  child:

  Column(
    children: [
      getTopToolbar(),

      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-50-32-293,
        child:
        SingleChildScrollView(
          child: Column(
            children: [
              getImageValue(),
              enterMenuDetails(),

            ],
          ),
        ),
      ),





    ],

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

                setState(() {
                  addItem=false;
                });
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
            child: Container(
              alignment: Alignment.center,
              child: Text("Save",style: TextStyle(fontSize: 18,color: Colors.white),),
              decoration: BoxDecoration(

                color: utils.getColorFromHex("#878787"),

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

                    _menuDescriptionError="Item Description is required";
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
Future pickImage()async{

  final _pickedFile=await _picker.getImage(source: ImageSource.gallery,);
  setState(() {
    _pickFile=File(_pickedFile.path);


  });

}

}