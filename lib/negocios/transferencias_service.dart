import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_proyecto3prograv/providers/respuesta_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class transferenciasService {
  final String baseUrl;
  String _respuestaAPI = "";
  transferenciasService(this.baseUrl);

  Future<Map<String, dynamic>> getAutorizacionVigente(
      {String cuentaOrigen,
      String identificacionOrigen,
      String cuentaDestino,
      String identificacionDestino,
      BuildContext context}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/Autorizaciones/vigente?cuentaOrigen=$cuentaOrigen&identificacionOrigen=$identificacionOrigen&cuentaDestino=$cuentaDestino&identificacionDestino=$identificacionDestino'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      _respuestaAPI = "Ha sucedio un error al recuperar la Autorizacion";
    }
    context.read<RespuestaProvider>().mensajeRespuesta(_respuestaAPI);
    return null;
  }
}

class correoService {
  Future<bool> enviarCorreo(
      String destinatario, String asunto, String mensaje) async {
    final url = Uri.parse(
        'https://tiusr9pl.cuc-carrera-ti.ac.cr/webapiproyecto3/api/correo/enviar');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(<String, dynamic>{
      'Correo': destinatario,
      'Asunto': asunto,
      'Mensaje': mensaje,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}

class transService {
  Future<void> registrarTransferencia({
    String bancoOrigen,
    String bancoDestino,
    String cuentaOrigen,
    String cuentaDestino,
    int monto,
    String cedulaOrigen,
    String cedulaDestino,
    String tipoCedulaOrigen,
    String tipoCedulaDestino,
    String moneda,
    String descripcion,
    String canal,
    String tipoTransaccionID,
  }) async {
    final url = Uri.parse(
        'https://tiusr9pl.cuc-carrera-ti.ac.cr/webapiproyecto3/api/Transferencias');

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = jsonEncode(<String, dynamic>{
      'BancoOrigen': bancoOrigen,
      'BancoDestino': bancoDestino,
      'CuentaOrigen': cuentaOrigen,
      'CuentaDestino': cuentaDestino,
      'Monto': monto,
      'CedulaOrigen': cedulaOrigen,
      'CedulaDestino': cedulaDestino,
      'TipoCedulaOrigen': tipoCedulaOrigen,
      'TipoCedulaDestino': tipoCedulaDestino,
      'Moneda': moneda,
      'Descripcion': descripcion,
      'Canal': canal,
      'Tipo_Transaccion_ID': tipoTransaccionID,
    });
    // Mostrar el cuerpo que se enviará al API
    print('Cuerpo a enviar: $body');
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      String mensaje = "Transaccion interbancaria exitosa";
      Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      String mensaje =
          jsonResponse['mensaje'].toString(); // Obtener el mensaje como string
      Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

class ObtenerMonedaService {
  Future<String> obtenerMonedaCuenta(String numeroCuenta) async {
    final url = Uri.parse(
        'https://tiusr9pl.cuc-carrera-ti.ac.cr/webapiproyecto3/api/movimientos/Moneda/$numeroCuenta/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse; // Devuelve la moneda en formato JSON
    } else if (response.statusCode == 404) {
      return null; // Cuenta no encontrada
    } else {
      throw Exception('Error al obtener la moneda por número de cuenta');
    }
  }
}
