

class submenu {
  String _submenuname;
  String _submeuid;
  String _imagelink;
  List<String> _modifiers;
  List<String> _subMenu;

  dynamic _price;

  submenu(this._submenuname, this._submeuid, this._imagelink, this._price,
      this._modifiers, this._subMenu);

  dynamic get price => _price;

  set price(dynamic value) {
    _price = value;
  }

  String get imagelink => _imagelink;

  set imagelink(String value) {
    _imagelink = value;
  }

  String get submeuid => _submeuid;

  set submeuid(String value) {
    _submeuid = value;
  }

  String get submenuname => _submenuname;

  set submenuname(String value) {
    _submenuname = value;
  }

  List<String> get subMenu => _subMenu;

  set subMenu(List<String> value) {
    _subMenu = value;
  }

  List<String> get modifiers => _modifiers;

  set modifiers(List<String> value) {
    _modifiers = value;
  }
}
