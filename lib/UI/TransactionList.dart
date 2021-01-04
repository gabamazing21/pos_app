import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/UI/MasterPanel.dart';
import 'package:pos_app/UI/MasterPanelItem.dart';
import 'package:pos_app/UI/MasterPanelTransaction.dart';
import 'package:pos_app/Utils/constants.dart';
import 'package:pos_app/Utils/tempovalue.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/Models/OrderDetail.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/UI/pass_code.dart';

class TransactionList extends StatefulWidget {
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderList();
  }

  int _selectedIndex;
  List<OrderDetails> orderList = List();
  bool isloading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: utils.getColorFromHex("#3D3D3D"),
            child: Stack(
              children: [
                Positioned(
                    right: 10,
                    top: 40,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: utils.getColorFromHex("#878787")),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 50,
                        ),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PassCode(
                                    voidCallback: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MasterPanel()),
                                          (route) => false);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text("Menu", style: KdashboardTextStyle),
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MasterPanelTransaction(),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  "Orders",
                                  style: KdashboardTextStyle,
                                ),
                              )),
                          GestureDetector(
                            onTap: () async {
                              print("clicked");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PassCode(
                                          voidCallback: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MasterPanelItem()),
                                                    (route) => false);
                                          },
                                        )),
                              );
                            },
                            child: ListTile(
                              title: Text(
                                "Items",
                                style: KdashboardTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Transactions",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: utils.getColorFromHex("#F1F1F1"),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: (!isloading)
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                            onTap: () {
                              MasterDetailScaffold.of(context)
                                  .detailsPaneNavigator
                                  .pushNamed(
                                      "TransactionDetails?id=${orderList.elementAt(index).orderId}");
                              setState(() {
                                _selectedIndex = index;
                              });
                              tempovalueInstance
                                      .getInstance()
                                      .currentOrderDetials =
                                  orderList.elementAt(index);
                            },
                            child: itemList(index, orderList.elementAt(index))),
                    itemCount: orderList.length,
                  )
                : Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: null,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          utils.getColorFromHex("#CC1313")),
                    ))));
  }

  Widget itemList(int index, OrderDetails orderDetails) {
    String date = '20180626170555';
    String dateWithT = date.substring(0, 8) + 'T' + date.substring(8);
    DateTime dateTime = DateTime.parse(dateWithT);

    return Ink(
      color: (_selectedIndex == index) ? Colors.lightGreen : Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 10,
              child: Image.asset(
                "assets/images/money.png",
                color: Colors.black,
                width: 40,
                height: 40,
              ),
            ),
            Positioned(
                top: 15,
                left: 60,
                child: Text(
                  "${utils.localcurrency(orderDetails.amount)}",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                )),
            Positioned(
                top: 18,
                right: 5,
                width: 100,
                child: Text(
                  "${utils.readTimestamp(orderDetails.orderCreation.millisecondsSinceEpoch)}",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )),
            Positioned(
                top: 40,
                left: 60,
                width: 150,
                child: Text(
                  "${orderDetails.orderId}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                )),
            Positioned(
                bottom: 0,
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ))
          ],
        ),
      ),
    );
  }
  //Todo Show the details of each order

  Future<void> getOrderList() async {
    orderList = await database().getOrderDetails();

    if (orderList.isEmpty) {
      getOrderList();
    } else {
      MasterDetailScaffold.of(context)
          .detailsPaneNavigator
          .pushNamed("TransactionDetails?id=${orderList.elementAt(0).orderId}");
      tempovalueInstance.getInstance().currentOrderDetials =
          orderList.elementAt(0);
      setState(() {
        isloading = false;
      });
    }
  }
}
