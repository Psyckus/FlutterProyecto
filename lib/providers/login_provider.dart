import 'package:flutter/material.dart';

class loginProvider with ChangeNotifier {
  String _nombreCliente = "";
  String get nombreCliente => _nombreCliente;

  String _username = "";
  String get username => _username;

  void setdatosCliente(String nombreCliente, String username) {
    _nombreCliente = nombreCliente;
    _username = username;
    notifyListeners();
  }
}
