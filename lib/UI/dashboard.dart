import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:pos_app/Firebase/database.dart';
import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/UI/Items.dart';
import 'package:pos_app/UI/MasterPanel.dart';
import 'package:pos_app/UI/MasterPanelItem.dart';
import 'package:pos_app/UI/MasterPanelTransaction.dart';
import 'package:pos_app/UI/pass_code.dart';
import 'package:pos_app/UI/slidepush.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:pos_app/Utils/constants.dart';

class dashboard extends StatefulWidget {
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State {
  List<Menu> allmenulist = List();
  bool isLoading = false;
  bool noItemAvailable = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMenu();
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    List<int> menulist = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 206;
    var _aspectRatio = _width / cellHeight;
    bool isloading = true;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: utils.getColorFromHex("#CC1313"),
        onPressed: () {
          MasterDetailScaffold.of(context)
              .detailsPaneNavigator
              .pushNamed('menuDetails');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      key: _navigatorKey,
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: utils.getColorFromHex("#3D3D3D"),
      ),
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
                              "Activities",
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
      body: Container(
        color: utils.getColorFromHex("#F1F1F1"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: (!isLoading)
            ? (!noItemAvailable)
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.height - 88 - 48 - 43,
                          child: ResponsiveGridList(
                              desiredItemWidth: 100,
                              minSpacing: 20,
                              children: allmenulist
                                  .map((e) => GestureDetector(
                                        child: MenuItem(e),
                                        onTap: () async {
                                          print("clicked");
                                          await MasterDetailScaffold.of(context)
                                              .detailsPaneNavigator
                                              .pushNamed(
                                                  'menuDetails?id=${e.id}');
                                          Future.delayed(Duration(seconds: 0),
                                              () {
//           if( Navigator.canPop(context))
//             Navigator.pop(context);

                                            // Navigator.of(context).pushNamed("menuDetails");
                                          });
                                        },
                                      ))
                                  .toList()),
                        )
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 88 - 48 - 43,
                    alignment: Alignment.center,
                    child: Text(
                      "No Menu Item yet",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 88 - 48 - 43,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  value: null,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      utils.getColorFromHex("#CC1313")),
                )),
      ),
    );
  }

  Widget AddItem() {
    return Container(
      child: FlatButton(
        child: Text(
          "Add Menu",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget MenuItem(Menu item) {
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
            // color: utils.getColorFromHex("#CC1313"),
            // child: Text(
            //   "${item.menu_name}",
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold),
            // ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(item.image_link),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 42,
            alignment: Alignment.center,
            width: 229,
            child: Text(
              "${item.menu_name}",
              style: TextStyle(fontSize: 12, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  Future<void> getMenu() async {
    allmenulist = await database.getMenu();
    if (allmenulist != null) {
      print("item is not null");
      if (allmenulist.isEmpty) {
        getMenu();
      } else {
        setState(() {
          isLoading = false;
          noItemAvailable = false;
        });
      }
    } else {
      print("item is nullffff");
      isLoading = false;
      noItemAvailable = true;
      setState(() {});
    }
  }
}
