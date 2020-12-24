import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_app/Models/OrderItem.dart';

class OrderDetails {
  String _userId;
  String _orderId;
  Timestamp _orderCreation;
   List<Orderitem> _product;
  dynamic _amount;
  dynamic _amountAvailable;
  dynamic _chargeToReceived;
  // bool _orderScanned;
  bool _orderInrestuurant;
  Timestamp _orderCompleted;

  OrderDetails(
      this._userId,
      this._orderId,
      this._orderCreation,
      // this._product,
      this._amount,
      this._amountAvailable,
      this._chargeToReceived,
      // this._orderScanned,
      this._orderInrestuurant,
      this._orderCompleted,
      this._product);

  Timestamp get orderCompleted => _orderCompleted;

  set orderCompleted(Timestamp value) {
    _orderCompleted = value;
  }

  bool get orderInrestuurant => _orderInrestuurant;

  set orderInrestuurant(bool value) {
    _orderInrestuurant = value;
  }

  // bool get orderScanned => _orderScanned;
  //
  // set orderScanned(bool value) {
  //   _orderScanned = value;
  // }

  double get chargeToReceived => _chargeToReceived;

  set chargeToReceived(double value) {
    _chargeToReceived = value;
  }

  double get amountAvailable => _amountAvailable;

  set amountAvailable(double value) {
    _amountAvailable = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  // List<Orderitem> get product => _product;
  //
  // set product(List<Orderitem> value) {
  //   _product = value;
  // }

  Timestamp get orderCreation => _orderCreation;

  set orderCreation(Timestamp value) {
    _orderCreation = value;
  }

  String get orderId => _orderId;

  set orderId(String value) {
    _orderId = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  List<Orderitem> get product => _product;

  set product(List<Orderitem> value) {
    _product = value;
  }
}
