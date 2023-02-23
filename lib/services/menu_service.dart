

import 'dart:async';

class _MenuService{

  static String _menuOptSelected = '';

  final StreamController<String> _menuStreamController = StreamController<String>.broadcast();
  Stream<String> get menuController => _menuStreamController.stream;


  void setMenuOpt(String opt){
    _menuOptSelected = opt;
    _menuStreamController.add(opt);
  }

  String getMenu(){
    return _menuOptSelected;
  }
}

final menuService = new _MenuService();