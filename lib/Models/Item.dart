class Item {
  String _itemName;
  String _itemId;
  dynamic _itemprice;
  bool _visibility;
  int _quantity = 0;
  String _imageLink;
  Item(this._itemName, this._itemId, this._itemprice, this._visibility,this._imageLink);


  String get imageLink => _imageLink;

  set imageLink(String value) {
    _imageLink = value;
  }

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  dynamic get itemprice => _itemprice;

  set itemprice(dynamic value) {
    _itemprice = value;
  }

  String get itemId => _itemId;

  set itemId(String value) {
    _itemId = value;
  }

  String get itemName => _itemName;

  set itemName(String value) {
    _itemName = value;
  }

  bool get visibility => _visibility;

  set visibility(bool value) {
    _visibility = value;
  }
}
