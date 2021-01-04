class Orderitem {
  String _orderItemname;
  int _quantity;
  dynamic _price;
   String _id;
   String _orderImageLink;
  Orderitem(this._id,this._orderItemname, this._quantity, this._price,this._orderImageLink);

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

  String get orderImageLink => _orderImageLink;

  set orderImageLink(String value) {
    _orderImageLink = value;
  }
}
