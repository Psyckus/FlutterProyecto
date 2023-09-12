// To parse this JSON data, do
//
//     final respuestaGenerica = respuestaGenericaFromJson(jsonString);

import 'dart:convert';

RespuestaGenerica respuestaGenericaFromJson(String str) => RespuestaGenerica.fromJson(json.decode(str));

String respuestaGenericaToJson(RespuestaGenerica data) => json.encode(data.toJson());

class RespuestaGenerica {
    int codigo;
    String mensaje;

    RespuestaGenerica({
        this.codigo,
        this.mensaje,
    });

    factory RespuestaGenerica.fromJson(Map<String, dynamic> json) => RespuestaGenerica(
        codigo: json["codigo"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "mensaje": mensaje,
    };
}
