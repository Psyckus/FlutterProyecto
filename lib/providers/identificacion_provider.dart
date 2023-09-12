import 'package:flutter/foundation.dart';

class IdentificacionProvider extends ChangeNotifier {
  String _numeroIdentificacion = '';

  String get numeroIdentificacion => _numeroIdentificacion;

  void setNumeroIdentificacion(String numeroIdentificacion) {
    _numeroIdentificacion = numeroIdentificacion;
    notifyListeners();
  }
}
