import 'package:flutter/material.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/submenu.dart';
import 'package:pos_app/UI/SubMenuDetails.dart';
import 'package:pos_app/Utils/utils.dart';

class SubMenu extends StatefulWidget{


  _SubMenuState createState()=> _SubMenuState();
}
class _SubMenuState extends State{
bool showEditsubMenu=false;
TextEditingController _searchController;
List<submenu> subMenuList=List();
submenu _currentSubMenu;
@override
  void initState() {
    // TODO: implement initState
  getSubmenuList();
  super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //appBar: AppBar(title: Text("SubMenu",style: TextStyle(fontSize: 16,color: Colors.black,)),backgroundColor: utils.getColorFromHex("#F1F1F1"),),

      body:(!showEditsubMenu) ?Container(
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
                  labelText: "Search Modifiers",
                  suffixIcon: Icon(Icons.search,size: 25,),
                  border: InputBorder.none,

                ),


              ),
            ),

            GestureDetector(
              onTap: (){
                _currentSubMenu=null;
                setState(() {
                  showEditsubMenu=true;
                });

              },
              child: Container(
                margin: EdgeInsets.only(top: 30,left: 20,right: 20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: FlatButton(child: Text("Add SubMenu",style: TextStyle(fontSize: 16,color: utils.getColorFromHex("#0D97FF")),),),


              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-218,
              child: ListView.builder(

                itemCount:subMenuList.length,
                itemBuilder: (BuildContext context,int index)=>GestureDetector(
                    onTap: (){

                      _currentSubMenu=subMenuList.elementAt(index);
                      setState(() {
                        showEditsubMenu=true;
                      });
                    },
                    child: _orderItem(subMenuList.elementAt(index))),
              ),
            )

          ],

        ),


      ):SubMenuDetails(_currentSubMenu),
    );


  }
Widget _orderItem(submenu item){

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
              child:Icon(Icons.menu,color: Colors.black,size: 20,)),
        ),
        Positioned(
            top: 5,
            left: 70,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item.submenuname}",style: TextStyle(fontSize: 25,color: Colors.black),),

              ],

            )),
        //Positioned(
          //  top: 10,
            //right: 10,
            //child: Text(item.items.length>1?"${item.items.length } items":"${item.items.length} item",style: TextStyle(fontSize: 18,color: Colors.black.withOpacity(0.5)),)),

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

Future<void> getSubmenuList()async{
  subMenuList= await database.getAllSubMenu();
  if(subMenuList.isEmpty){

    getSubmenuList();
  }else{

    setState(() {

    });
  }


}
}