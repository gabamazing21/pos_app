import 'package:flutter/material.dart';
import 'package:pos_app/Utils/utils.dart';

class Modifiers extends StatefulWidget{

  _ModifierState createState()=>_ModifierState();
}
class _ModifierState extends State{
  TextEditingController _searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Modifiers",style: TextStyle(fontSize: 16,color: Colors.black,)),backgroundColor: utils.getColorFromHex("#F1F1F1"),),

      body: Container(
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

            Container(
              margin: EdgeInsets.only(top: 30,left: 20,right: 20),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: FlatButton(child: Text("Add Item",style: TextStyle(fontSize: 16,color: utils.getColorFromHex("#0D97FF")),),),


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


      ),
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
              child: Text("2 items",style: TextStyle(fontSize: 18,color: Colors.black.withOpacity(0.5)),)),

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


}