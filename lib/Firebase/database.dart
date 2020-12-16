import 'dart:async';
import 'dart:core';
import 'package:pos_app/Models/OrderDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_app/Models/Item.dart';
import 'package:pos_app/Models/Menu.dart';
import 'package:pos_app/Models/modifier.dart';
import 'package:pos_app/Models/submenu.dart';

class database {
  static CollectionReference subMenuRef() =>
      FirebaseFirestore.instance.collection("subMenu");

  static CollectionReference menuRef() =>
      FirebaseFirestore.instance.collection("menus");

  static CollectionReference ItemRef() =>
      FirebaseFirestore.instance.collection("Items");

  static CollectionReference modifierRef() =>
      FirebaseFirestore.instance.collection("Modifiers");
  static CollectionReference orderRef() =>
      FirebaseFirestore.instance.collection("Orders");

  static Future<List<Menu>> getMenu() async {
    List<Menu> mitem = List();

    menuRef().snapshots().listen((event) {
      event.docs.forEach((element) {
        Menu item = new Menu(
            element['menuName'],
            (element["subMenu"] != null ? List.from(element['subMenu']) : null),
            element['imageLink'],
            element['visibility']);

        mitem.add(item);
        print(item.menu_name);
      });
    });

    // return Future.delayed(Duration(seconds: 1), () => mitem);
    return Future.delayed(Duration(seconds: 1), () => mitem);
  }

  static Future<List<submenu>> getAllSubMenu() {
    List<submenu> items = List();
    subMenuRef().snapshots().listen((event) {
      event.docs.forEach((value) {
        items.add(new submenu(
            value['title'],
            value.id,
            value['imageUrl'],
            0.0,
            List.from(value['modifiers']),
            (value["subMenu"] != null) ? List.from(value['subMenu']) : null));
      });
    });
    return Future.delayed(Duration(seconds: 1), () => items);
  }

  static Future<Item> getItem(String id) async {
    Item item;
    var itemref = await ItemRef().doc(id).get().then((value) => item = new Item(
        value['itemName'], value.id, value['ItemPrice'], value['visible']));

    return item;
  }

  static Future<List<Item>> getAllItem(List<String> ids) async {
    List<Item> itemList = List();
    await ids.forEach((element) async {
      Item item = await getItem(element);
      itemList.add(item);
    });
    return Future.delayed(Duration(seconds: 1), () => itemList);
  }

  static Future<List<Item>> getItems() async {
    List<Item> itemList = List();
    ItemRef().snapshots().listen((event) {
      event.docs.forEach((element) {
        Item item = new Item(element['itemName'], element.id,
            element['ItemPrice'], element['visible']);
        itemList.add(item);
      });
    });

    return Future.delayed(Duration(seconds: 1), () => itemList);
  }

  static Future<submenu> getsubmenu(String id) async {
    submenu item;
    var submenuref = await subMenuRef().doc(id).get().then((value) => item =
        new submenu(
            value['title'],
            value.id,
            value['imageUrl'],
            0.0,
            List.from(value['modifiers']),
            (value["subMenu"] != null) ? List.from(value['subMenu']) : null));
    return item;
  }

  static Future<List<submenu>> getAllSubMenuList(List<String> ids) async {
    List<submenu> itemlist = List();
    await ids.forEach((element) async {
      submenu item = await getsubmenu(element);
      itemlist.add(item);
      print(item.submenuname);
    });

    return Future.delayed(Duration(seconds: 1), () => itemlist);
  }

  static Future<modifiers> getModifier(String id) async {
    modifiers item;
    var modifierRRef = await modifierRef().doc(id).get().then((value) => item =
        new modifiers(id, value['modifiersName'], List.from(value["items"]), 0,
            value['checkBox']));

    return item;
  }

  static Future<List<modifiers>> getAllModifier() {
    List<modifiers> items = List();
    modifierRef().snapshots().listen((event) {
      event.docs.forEach((element) {
        modifiers item = new modifiers(element.id, element['modifiersName'],
            List.from(element["items"]), 0, element['checkBox']);
        items.add(item);
      });
    });
    return Future.delayed(Duration(seconds: 1), () => items);
  }

  static Future<List<modifiers>> getAllModifierList(List<String> ids) async {
    List<modifiers> itemlist = List();

    ids.forEach((element) async {
      modifiers item = await getModifier(element);

      itemlist.add(item);
      print(item.modifier_name);
//return itemlist;
    });

//return itemlist;

    return Future.delayed(Duration(seconds: 1), () => itemlist);
  }

//TOdo Get the list of Order on Firebase and create the method that required the List of Order under Database Clss

  Future<List<OrderDetails>> getOrderDetails() async {
    List<OrderDetails> orderDetails = List();
    orderRef().snapshots().listen((event) {
      event.docs.forEach((element) {
        OrderDetails orders = new OrderDetails(
          element['userId'],
          element['orderId'],
          element['orderCreation'],
          element['amount'],
          element['amountAvailable'],
          element['changeToReceived'],
          element['orderInRestaurant'],
          element['orderCompleted'],
        );

        orderDetails.add(orders);
        print(orders.orderId);
      });
    });

    return Future.delayed(Duration(seconds: 1), () => orderDetails);
  }

//Todo Also copy the Model for Order on the Previous App and Paste it inside the model of the pos app

}
