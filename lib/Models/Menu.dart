
class Menu {
  String _menu_name;
  List<String> _sub_menu;
  String _image_link;
  bool _visibility;
  dynamic _price;
  dynamic _promoprice;
  String _decription;
  String _id;

  Menu(this._id,this._menu_name, this._sub_menu, this._image_link, this._visibility);

  String get image_link => _image_link;

  set image_link(String value) {
    _image_link = value;
  }


  String get id => _id;

  set id(String value) {
    _id = value;
  }

  dynamic get promoprice => _promoprice;

  set promoprice(dynamic value) {
    _promoprice = value;
  }

  List<String> get sub_menu => _sub_menu;

  set sub_menu(List<String> value) {
    _sub_menu = value;
  }

  String get menu_name => _menu_name;

  set menu_name(String value) {
    _menu_name = value;
  }

  bool get visibility => _visibility;

  set visibility(bool value) {
    _visibility = value;
  }

  dynamic get price => _price;

  set price(dynamic value) {
    _price = value;
  }

  String get decription => _decription;

  set decription(String value) {
    _decription = value;
  }
}
