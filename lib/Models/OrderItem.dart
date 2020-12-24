class Orderitem {
  String _orderItemname;
  int _quantity;
  dynamic _price;
   String _id;
  Orderitem(this._id,this._orderItemname, this._quantity, this._price);

  dynamic get price => _price;

  set price(dynamic value) {
    _price = value;
  }

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  String get orderItemname => _orderItemname;

  set orderItemname(String value) {
    _orderItemname = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
