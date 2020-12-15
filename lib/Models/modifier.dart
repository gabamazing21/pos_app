import 'package:flutter/material.dart';


class modifiers{
String _modifier_name;
List<String> _items;
int _required_item_num;
bool _checkboxreq;
String _id;
modifiers(this._id,this._modifier_name, this._items, this._required_item_num,
      this._checkboxreq);

bool get checkboxreq => _checkboxreq;

  set checkboxreq(bool value) {
    _checkboxreq = value;
  }

String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get required_item_num => _required_item_num;

  set required_item_num(int value) {
    _required_item_num = value;
  }

  List<String> get items => _items;

  set items(List<String> value) {
    _items = value;
  }

  String get modifier_name => _modifier_name;

  set modifier_name(String value) {
    _modifier_name = value;
  }
}