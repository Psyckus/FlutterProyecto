import 'package:flutter/material.dart';

class ProductoProvider with ChangeNotifier {
  String _codigo = "";
  String get codigo => _codigo;

  void setCodigo(String codigo) {
    _codigo = codigo;    
    notifyListeners();
  }
}