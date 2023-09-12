import 'package:flutter/material.dart';

class RespuestaProvider with ChangeNotifier {
  String _mensaje = "";
  String get mensaje => _mensaje;

  void mensajeRespuesta(String mensaje) {
    _mensaje = mensaje;
    notifyListeners();
  }
}
