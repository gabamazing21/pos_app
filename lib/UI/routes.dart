 import 'package:flutter/material.dart';
import 'package:pos_app/UI/Demo.dart';
import 'package:pos_app/UI/Items.dart';
import 'package:pos_app/UI/MasterPanelTransaction.dart';
class routes {
static  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        print("demo found");
        return MaterialPageRoute(builder: (_) => Demo());

      case '/transactionList':
        print("transactionList route");
        return MaterialPageRoute(builder: (_) => Item());
      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}