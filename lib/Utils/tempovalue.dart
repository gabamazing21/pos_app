import 'package:pos_app/Models/OrderDetail.dart';

class tempovalue {
  OrderDetails _currentOrderDetials;
  String _passcode;

  String get passcode => _passcode;

  set passcode(String value) {
    _passcode = value;
  }

  OrderDetails get currentOrderDetials => _currentOrderDetials;

  set currentOrderDetials(OrderDetails value) {
    _currentOrderDetials = value;
  }
}

class tempovalueInstance {
  static tempovalue _instance = tempovalue();

  static tempovalue getInstance() {
    return _instance;
  }
}
