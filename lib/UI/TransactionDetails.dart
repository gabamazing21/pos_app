import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/OrderDetail.dart';
import 'package:pos_app/Models/OrderItem.dart';
import 'package:pos_app/UI/printing.dart';
import 'package:pos_app/Utils/tempovalue.dart';
import 'package:pos_app/Utils/utils.dart';

class TransactionDetails extends StatefulWidget {
  _TransactonDetailsState createState() => _TransactonDetailsState();
}

class _TransactonDetailsState extends State {
  bool showPrint = false;
  OrderDetails currentOrders;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentOrders = tempovalueInstance.getInstance().currentOrderDetials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: (!showPrint)
            ? (currentOrders != null)
                ? Column(
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: 100),
                          width: MediaQuery.of(context).size.width - 245,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 0,
                                  right: 5,
                                ),
                                width: (MediaQuery.of(context).size.width - 255),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.grey.shade200,
                                    ),
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    width:
                                        (MediaQuery.of(context).size.width / 2) -
                                            105 -
                                            25,
                                    child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          showPrint = true;
                                        });
                                        // MasterDetailScaffold.of(context)
                                        //     .detailsPaneNavigator
                                        //     .pushNamed(
                                        //         "TransactionDetails?id=printing");
                                      },
                                      child: Text(
                                        "Print Receipt",
                                        style: TextStyle(
                                            color:
                                                utils.getColorFromHex("#0D97FF"),
                                            fontSize: 35),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          margin: EdgeInsets.only(top: 50, left: 20),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "Cash Payment",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black)),
                            TextSpan(
                                text:
                                    " ${utils.readTimestamp(currentOrders.orderCreation.millisecondsSinceEpoch)}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: utils.getColorFromHex("#878787")))
                          ]))),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Divider(
                          height: 1,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 10,
                                left: 5,
                                child: Image(
                                  image: AssetImage("assets/images/money.png"),
                                  height: 50,
                                  width: 50,
                                  color: Colors.black,
                                )),
                            Positioned(
                                top: 20,
                                left: 80,
                                child: Text(
                                  "Cash",
                                  style: TextStyle(
                                      color: utils.getColorFromHex("#3D3D3D"),
                                      fontSize: 25),
                                )),
                            Positioned(
                                top: 20,
                                right: 0,
                                child: Text(
                                  "${utils.localcurrency(currentOrders.amount)}",
                                  style: TextStyle(
                                      color: utils.getColorFromHex("#878787"),
                                      fontSize: 25),
                                )),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Divider(
                                    height: 1,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 0, right: 0),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 10,
                                left: 20,
                                child: Image(
                                  image:
                                      AssetImage("assets/images/invoice.png"),
                                  height: 50,
                                  width: 50,
                                  color: Colors.black,
                                )),
                            Positioned(
                                top: 20,
                                left: 100,
                                child: Text(
                                  "Receipt ${currentOrders.orderId}",
                                  style: TextStyle(
                                      color: utils.getColorFromHex("#3D3D3D"),
                                      fontSize: 25),
                                )),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Divider(
                                    height: 1,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 20, right: 20),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 50, bottom: 10, left: 20),
                        child: Text(
                          "Ticket ${currentOrders.orderId}",
                          style: TextStyle(
                              color: utils.getColorFromHex("#3D3D3D"),
                              fontSize: 25),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60.0 * currentOrders.product.length,
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 10),
                          itemCount: currentOrders.product.length,
                          itemBuilder: (BuildContext context, int index) =>
                              _orderItem(
                                  currentOrders.product.elementAt(index)),
                          //children:currentOrders.product.map((e) => _orderItem(e)).toList()
                        ),
                      )
                    ],
                  )
                : Container()
            : MyPrint(currentOrders, () {
                setState(() {
                  showPrint = false;
                });
              }),
      ),
    );
  }

  Widget _orderItem(Orderitem item) {
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
                child: Image.asset(
                  "assets/images/fast_food.jpg",
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
                    "${item.orderItemname}",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  Text(
                    "x ${item.quantity}",
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.4)),
                  )
                ],
              )),
          Positioned(
              top: 10,
              right: 10,
              child: Text(
                "${utils.localcurrency(item.price)}",
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
}
