// To parse this JSON data, do
//
//     final transferencias = transferenciasFromJson(jsonString);

import 'dart:convert';

Transferencias transferenciasFromJson(String str) =>
    Transferencias.fromJson(json.decode(str));

String transferenciasToJson(Transferencias data) => json.encode(data.toJson());

class Transferencias {
  String bancoOrigen;
  String bancoDestino;
  String cuentaOrigen;
  String cuentaDestino;
  int monto;
  String cedulaOrigen;
  String cedulaDestino;
  String tipoCedulaOrigen;
  String tipoCedulaDestino;
  String moneda;
  String descripcion;
  String motivo;
  String canal;
  String tipoTransaccionId;
  String codigoRefencia;

  Transferencias({
    this.bancoOrigen,
    this.bancoDestino,
    this.cuentaOrigen,
    this.cuentaDestino,
    this.monto,
    this.cedulaOrigen,
    this.cedulaDestino,
    this.tipoCedulaOrigen,
    this.tipoCedulaDestino,
    this.moneda,
    this.descripcion,
    this.motivo,
    this.canal,
    this.tipoTransaccionId,
    this.codigoRefencia,
  });

  factory Transferencias.fromJson(Map<String, dynamic> json) => Transferencias(
        bancoOrigen: json["BancoOrigen"],
        bancoDestino: json["BancoDestino"],
        cuentaOrigen: json["CuentaOrigen"],
        cuentaDestino: json["CuentaDestino"],
        monto: json["Monto"],
        cedulaOrigen: json["CedulaOrigen"],
        cedulaDestino: json["CedulaDestino"],
        tipoCedulaOrigen: json["TipoCedulaOrigen"],
        tipoCedulaDestino: json["TipoCedulaDestino"],
        moneda: json["Moneda"],
        descripcion: json["Descripcion"],
        motivo: json["Motivo"],
        canal: json["Canal"],
        tipoTransaccionId: json["Tipo_Transaccion_ID"],
        codigoRefencia: json["codigoRefencia"],
      );

  Map<String, dynamic> toJson() => {
        "BancoOrigen": bancoOrigen,
        "BancoDestino": bancoDestino,
        "CuentaOrigen": cuentaOrigen,
        "CuentaDestino": cuentaDestino,
        "Monto": monto,
        "CedulaOrigen": cedulaOrigen,
        "CedulaDestino": cedulaDestino,
        "TipoCedulaOrigen": tipoCedulaOrigen,
        "TipoCedulaDestino": tipoCedulaDestino,
        "Moneda": moneda,
        "Descripcion": descripcion,
        "Motivo": motivo,
        "Canal": canal,
        "Tipo_Transaccion_ID": tipoTransaccionId,
        "codigoRefencia": codigoRefencia,
      };
}
