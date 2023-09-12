// To parse this JSON data, do
//
//     final infoProducto = infoProductoFromJson(jsonString);

import 'dart:convert';

//InfoProducto infoProductoFromJson(String str) => InfoProducto.fromJson(json.decode(str));


List<InfoCuentaxcliente> productosFromJsonn(String str) => List<InfoCuentaxcliente>.from(json.decode(str).map((x) => InfoCuentaxcliente.fromJson(x)));


String infoProductoToJson(InfoCuentaxcliente data) => json.encode(data.toJson());


//List<InfoProducto> infoProductoFromJson(String str) => List<InfoProducto>.from(json.decode(str));

//String infoProductoToJson(List<InfoProducto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InfoCuentaxcliente {
    String numerocuenta;
    double saldo;
    String tipocuenta;

    InfoCuentaxcliente({
        this.numerocuenta,
        this.saldo,
        this.tipocuenta
    });

    factory InfoCuentaxcliente.fromJson(Map<String, dynamic> json) => InfoCuentaxcliente(
        numerocuenta: json["NumeroCuenta"],
        saldo: json["Saldo"],
        tipocuenta: json["TipoCuenta"],
    );

    Map<String, dynamic> toJson() => {
        "numerocuenta": numerocuenta,
        "saldo": saldo,
        "tipocuenta": tipocuenta
    };
}
