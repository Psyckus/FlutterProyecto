import 'package:flutter_proyecto3prograv/models/info_login.dart';
import 'package:flutter_proyecto3prograv/models/respuesta_generica.dart';
import 'package:flutter_proyecto3prograv/providers/login_provider.dart';
import 'package:flutter_proyecto3prograv/providers/respuesta_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginService {
  static Future<String> iniciarlogin(Login login, BuildContext context) async {
    String _respuestaAPI = "";

    var url = Uri.parse(
        "https://tiusr9pl.cuc-carrera-ti.ac.cr/webapiproyecto3/usuarios/login");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(login.toJson()),
    );

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, extrae y devuelve el valor de "nombreCliente"
      Map<String, dynamic> responseData = json.decode(response.body);
      String nombreCliente = responseData['nombre'];
      context.read<loginProvider>().setdatosCliente(responseData['nombre'],login.username);
      return nombreCliente;
    } else if (response.statusCode == 404) {
      _respuestaAPI = "Usuario y/o contraseña incorrectos.";
    } else if (response.statusCode == 409) {
      RespuestaGenerica respuesta = respuestaGenericaFromJson(response.body);
      _respuestaAPI = respuesta.mensaje;
    } else {
      _respuestaAPI = "Ha ocurrido un error intente de nuevo.";
    }

    context.read<RespuestaProvider>().mensajeRespuesta(_respuestaAPI);
    return null;
  }
}

