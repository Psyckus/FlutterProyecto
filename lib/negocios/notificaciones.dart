import 'package:flutter/material.dart';
import 'package:flutter_proyecto3prograv/providers/respuesta_provider.dart';
import 'package:provider/provider.dart';


class Alertas {
  static void notificacion(String mensaje, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(mensaje),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    context.read<RespuestaProvider>().mensajeRespuesta("");
  }
}
