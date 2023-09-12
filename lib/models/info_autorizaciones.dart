// To parse this JSON data, do
//
//     final autorizaciones = autorizacionesFromJson(jsonString);

import 'dart:convert';

Autorizaciones autorizacionesFromJson(String str) => Autorizaciones.fromJson(json.decode(str));

String autorizacionesToJson(Autorizaciones data) => json.encode(data.toJson());

class Autorizaciones {
    //String codigo;
    String entidadOrigen;
    String entidadDestino;
    String cuentaOrigen;
    String cuentaDestino;
    String identificacionOrigen;
    String identificacionDestino;
    String fechaInicio;
    String fechaFinalizacion;
    String estado;

    Autorizaciones({
        //this.codigo,
        this.entidadOrigen,
        this.entidadDestino,
        this.cuentaOrigen,
        this.cuentaDestino,
        this.identificacionOrigen,
        this.identificacionDestino,
        this.fechaInicio,
        this.fechaFinalizacion,
        this.estado,
    });

    factory Autorizaciones.fromJson(Map<String, dynamic> json) => Autorizaciones(
        //codigo: json["Codigo"],
        entidadOrigen: json["Entidad_Origen"],
        entidadDestino: json["Entidad_Destino"],
        cuentaOrigen: json["Cuenta_Origen"],
        cuentaDestino: json["Cuenta_Destino"],
        identificacionOrigen: json["identificacion_Origen"],
        identificacionDestino: json["identificacion_Destino"],
        fechaInicio: json["Fecha_Inicio"],
        fechaFinalizacion: json["Fecha_Finalizacion"],
        estado: json["Estado"],
    );

    Map<String, dynamic> toJson() => {
        //"Codigo": codigo,
        "Entidad_Origen": entidadOrigen,
        "Entidad_Destino": entidadDestino,
        "Cuenta_Origen": cuentaOrigen,
        "Cuenta_Destino": cuentaDestino,
        "identificacion_Origen": identificacionOrigen,
        "identificacion_Destino": identificacionDestino,
        "Fecha_Inicio": fechaInicio,
        "Fecha_Finalizacion": fechaFinalizacion,
        "Estado": estado,
    };
}
