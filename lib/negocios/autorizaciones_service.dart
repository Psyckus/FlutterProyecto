import 'dart:convert';

import 'package:flutter_proyecto3prograv/models/info_autorizaciones.dart';
import 'package:flutter_proyecto3prograv/models/respuesta_generica.dart';
import 'package:flutter_proyecto3prograv/providers/respuesta_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/info_cuentaxcliente.dart';

class AutorizacionesService {
  //Crear un producto
  static Future<bool> crearAutorizacion(
      Autorizaciones Autorizaciones, BuildContext context) async {
    String _respuestaAPI = "";

    var url = Uri.parse(
        "https://tiusr9pl.cuc-carrera-ti.ac.cr/webapiproyecto3/api/Autorizaciones");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(Autorizaciones.toJson()),
    );

    if (response.statusCode == 201) {
      _respuestaAPI = "La autorización ha sido registrada";
    } else if (response.statusCode == 400) {
      _respuestaAPI = "No sé pudo registrar la autorizacion: 400";
    } else if (response.statusCode == 409) {
      RespuestaGenerica respuesta = respuestaGenericaFromJson(response.body);
      _respuestaAPI = respuesta.mensaje;
    } else {
      _respuestaAPI = "Error en la API";
    }

    context.read<RespuestaProvider>().mensajeRespuesta(_respuestaAPI);
    if (response.statusCode == 201) {
      return false;
    }
    return true;
  }

  static Future<List<InfoCuentaxcliente>> getCuentaXcliente(
      String identificaicon) async {
    String _productoURL =
        "https://tiusr9pl.cuc-carrera-ti.ac.cr/webapiproyecto3/api/clientes/ObtenerCuentasXCliente?N_Identificacion=$identificaicon";

    var url = Uri.parse(_productoURL);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<InfoCuentaxcliente> infoProductos =
          productosFromJsonn(response.body);
      return infoProductos;
    } else {
      return null;
    }
  }
}
