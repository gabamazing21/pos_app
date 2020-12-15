import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:responsive_grid/responsive_grid.dart';
class dashboard extends StatefulWidget{

  _dashboardState createState()=>_dashboardState();
}
class _dashboardState extends State{

  List<Menu> allmenulist=List();
  bool isloading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getMenu();

  }
  @override
  Widget build(BuildContext context) {

    var _crossAxisSpacing = 8;
    List<int> menulist=[1,2,3,4,5,6,7,8,9];
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight =206;
    var _aspectRatio = _width / cellHeight;

return Scaffold(
  appBar: AppBar(title: Text("Dashboard"),backgroundColor: utils.getColorFromHex("#3D3D3D"),),
  drawer: Drawer(

    child: Container(
      color: utils.getColorFromHex("#3D3D3D"),
      child: Stack(
        children: [
          Positioned(
              right: 10,
              top: 40,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(

                  height: 50,
                  width: 50,
            decoration: BoxDecoration(

                shape: BoxShape.circle,
                color: utils.getColorFromHex("#878787")
            ),
            child: Icon(Icons.close,color: Colors.white,size: 50,),

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
                ListTile(title: Text("Orders",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),),

                ListTile(title: Text("Transactions",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),),
                
                ListTile(title: Text("Items",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),),
                ListTile(title: Text("Modifiers",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),)


              ],


            ),

          )),



        ],


      ),



    ),
  ),
body: Container(
  color: Colors.black,

  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height,
  child: Column(
    children: [
       GestureDetector(
           onTap: (){
             MasterDetailScaffold.of(context)
                 .detailsPaneNavigator
                 .pushNamed('menuDetails');


           },

           child: AddItem()),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-88-48,
        child:
          ResponsiveGridList(

desiredItemWidth: 100,
          minSpacing: 20,
          children: allmenulist.map((e) => GestureDetector(child: MenuItem(e),onTap: (){
            MasterDetailScaffold.of(context)
                .detailsPaneNavigator
                .pushNamed('menuDetails');

          },)).toList()
        ),


      ),
    ],
  ),


),
);


  }
  Widget AddItem(){
    return Container(child: FlatButton(child: Text("Add Menu",style: TextStyle(fontSize: 20,color: Colors.white,),),),);


  }
  Widget MenuItem(Menu item){

    return Container(
      width: 229,
      height: 210,
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: 229,
            height: 164,
            color: utils.getColorFromHex("#CC1313"),

               child: Text("${item.menu_name}", maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),


          ),
          Container(
            color: Colors.white,
            height: 42,

            alignment: Alignment.center,
            width: 229,
            child: Text("${item.menu_name}",style: TextStyle(fontSize: 12,color: Colors.black),overflow: TextOverflow.ellipsis,maxLines: 1,),
          )

        ],


      ),




    );


  }
  Future<void> getMenu()async{
    setState(() {
      isloading=true;
    });
    allmenulist=await database.getMenu();
    if(allmenulist.isEmpty){

      getMenu();
    }else{
      setState(() {
        isloading=false;
      });

    }


  }
}