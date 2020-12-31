import 'package:flutter/material.dart';
import 'package:pos_app/Utils/utils.dart';

class ToolBar extends StatelessWidget {
  VoidCallback callback;
  String title;

  ToolBar({this.callback, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 75.0,
      color: utils.getColorFromHex("#F1F1F1"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 10,
            ),
            child: GestureDetector(
              onTap: () {
                callback();
              },
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
