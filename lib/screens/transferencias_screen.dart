import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../models/info_cuentaxcliente.dart';
import '../negocios/autorizaciones_service.dart';
import '../negocios/transferencias_service.dart';
import '../providers/identificacion_provider.dart';

class transferencias extends StatefulWidget {
  @override
  State<transferencias> createState() => _transferenciasState();
}

class _transferenciasState extends State<transferencias> {
  bool _guardando = false;
  Future<List<InfoCuentaxcliente>> _cuentaCliente;
  String _valueDrop = "";
  List<String> _dataList = [];
  final _cuentaOrigenController = TextEditingController();
  final _cuentaDestinoController = TextEditingController();
  final _identificacionDestinoController = TextEditingController();
  final _montoController = TextEditingController();
  final _CorreoController = TextEditingController();
  final _ConceptoController = TextEditingController();
  bool _cargarModal = false;
  final _cuentaDestinoFocusNode = FocusNode();
  final _identificacionDestinoFocusNode = FocusNode();
  bool _camposCompletos = false;
  //identificacion origen no se pide ya que va hacer la identificacion del usuario logueado

  Widget _crearBoton(
      String infoMostrar, double valorHorizontal, double valorVertical) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _guardando = true;
        });
        registrarTransferencia();
        enviarCorreo();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: valorHorizontal, vertical: valorVertical),
        child: Text(infoMostrar),
      ),
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // Obtener el número de identificación desde el IdentificacionProvider
    String numeroIdentificacion =
        Provider.of<IdentificacionProvider>(context, listen: false)
            .numeroIdentificacion;

    //_codigo = Provider.of<ProductoProvider>(context, listen: false).codigo;
    _cuentaCliente =
        AutorizacionesService.getCuentaXcliente(numeroIdentificacion);
    _cuentaCliente.then(
      (x) => {
        if (x.length != 0)
          {
            x.forEach(
              (producto) {
                _dataList = x.map((producto) => producto.numerocuenta).toList();
              },
            ),
            setState(() {
              _cargarModal = true;
            })
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar(),
      body: _crearCuerpo(),
    );
  }

  Widget _crearAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text("Transferencias"),
    );
  }

  Widget _crearCuerpo() {
    return ModalProgressHUD(
      inAsyncCall: _guardando,
      child: _crearFormulario(),
    );
  }

  Widget _crearFormulario() {
    _identificacionDestinoFocusNode.addListener(() {
      if (!_identificacionDestinoFocusNode.hasFocus) {
        _obtenerYMostrarAutorizacion();
      }
    });
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearDropdown("Seleccione una cuenta", _dataList),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTexto(
              "Número de cuenta Destino de los fondos",
              _cuentaDestinoController,
              focusNode: _cuentaDestinoFocusNode,
            ),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTexto(
              "Identificación dueña de la cuenta destino",
              _identificacionDestinoController,
              focusNode: _identificacionDestinoFocusNode,
            ),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoint('Monto', _montoController),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTexto("Correo notificacion", _CorreoController),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTexto("Concepto", _ConceptoController),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearBoton("Transferir", 20, 12),
          ],
        ),
      ],
    );
  }

  Widget _crearCampoTexto(
    String placeholder,
    TextEditingController controller, {
    FocusNode focusNode,
  }) {
    return Container(
      height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          hintText: placeholder,
          labelText: placeholder,
        ),
      ),
    );
  }

  Widget _crearCampoint(String placeholder, TextEditingController controller) {
    return Container(
      height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number, // Teclado numérico
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Solo permite números
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          hintText: placeholder,
          labelText: placeholder,
        ),
      ),
    );
  }

  Widget _crearDropdown(String placeholder, List<String> dataList) {
    return Container(
      height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: DropdownButtonFormField(
        value: _valueDrop.isNotEmpty
            ? _valueDrop
            : null, // Establecer el valor predeterminado
        items: [
          DropdownMenuItem(
            child: Text("Seleccione una cuenta"),
            value: "",
          ),
          ...dataList.map((name) {
            return DropdownMenuItem(
              child: Text(name),
              value: name,
            );
          }).toList(),
        ],
        onChanged: (value) {
          setState(() {
            _valueDrop = value;
          });
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          hintText: placeholder,
          labelText: placeholder,
        ),
      ),
    );
  }

  Future<void> registrarTransferencia() async {
    if (_valueDrop.isEmpty ||
        _cuentaDestinoController.text.isEmpty ||
        _ConceptoController.text.isEmpty ||
        _cuentaDestinoController.text.isEmpty ||
        _identificacionDestinoController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Completa todos los campos obligatorios',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        _guardando = false;
      });
      return;
    }
    String numeroIdentificacion =
        Provider.of<IdentificacionProvider>(context, listen: false)
            .numeroIdentificacion;
    ObtenerMonedaService serviceMoneda = ObtenerMonedaService();
    String cuentaOrigen = _valueDrop;
    String moneda = await serviceMoneda.obtenerMonedaCuenta(cuentaOrigen);
    transService service = new transService();
    String cuentaDestino = _cuentaDestinoController.text;
    String valorObtenido = cuentaDestino.substring(
        2, 5); // Obtén el valor desde el índice 2 hasta el 5 (exclusivo)
    // Validar campos obligatorios
    if (_identificacionDestinoController.text != numeroIdentificacion) {
      // Si son iguales, se debe pedir una autorización obligatoriamente
      final autorizacion = await _getAutorizacionVigente();
      if (autorizacion == null) {
        _mostrarError('Se requiere una autorización para esta transferencia.');
        setState(() {
          _guardando = false;
        });
        return;
      }
    }
    await service.registrarTransferencia(
      bancoOrigen: '001',
      bancoDestino: valorObtenido,
      cuentaOrigen: _valueDrop,
      cuentaDestino: _cuentaDestinoController.text,
      monto: int.tryParse(_montoController.text) ?? 0,
      cedulaOrigen: numeroIdentificacion,
      cedulaDestino: _identificacionDestinoController.text,
      tipoCedulaOrigen: 'Nacional',
      tipoCedulaDestino: 'Nacional',
      moneda: moneda,
      descripcion: _ConceptoController.text,
      canal: 'Web',
      tipoTransaccionID: 'Solicitud',
    );
    // Limpiar los campos
    _cuentaDestinoController.clear();
    _identificacionDestinoController.clear();
    _montoController.clear();
    _CorreoController.clear();
    _ConceptoController.clear();
    setState(() {
      _guardando = false;
    });
  }

  Future<void> enviarCorreo() async {
    correoService service = correoService();
    String NumeroCuenta = _cuentaDestinoController.text;
    String monto = _montoController.text;
    String contenido =
        'Ha recibido una solicitud de fondos en su cuenta $NumeroCuenta por un monto de $monto';
    String correoEnviar = _CorreoController.text;
    bool exito = await service.enviarCorreo(
        correoEnviar, 'Transferencia Interbancaria', contenido);
    if (exito) {
      print('Correo enviado exitosamente.');
    } else {
      print('Error al enviar el correo.');
    }
  }

  Future<Map<String, dynamic>> _getAutorizacionVigente() async {
    try {
      String numeroIdentificacion =
          Provider.of<IdentificacionProvider>(context, listen: false)
              .numeroIdentificacion;
      String cuentaOrigen = _valueDrop;
      String identificacionOrigen =
          numeroIdentificacion; // Obtén la identificación del usuario logueado
      String cuentaDestino = _cuentaDestinoController.text;
      String identificacionDestino = _identificacionDestinoController.text;
      // Imprimir los valores de las variables antes de usarlas
      print('cuentaOrigen: $cuentaOrigen');
      print('identificacionOrigen: $identificacionOrigen');
      print('cuentaDestino: $cuentaDestino');
      print('identificacionDestino: $identificacionDestino');
      final apiService = transferenciasService(
          'https://tiusr9pl.cuc-carrera-ti.ac.cr/webapiproyecto3'); // Reemplaza con la URL de tu API
      return await apiService.getAutorizacionVigente(
        cuentaOrigen: cuentaOrigen,
        identificacionOrigen: identificacionOrigen,
        cuentaDestino: cuentaDestino,
        identificacionDestino: identificacionDestino,
      );
    } catch (e) {
      print('Error al obtener la autorización: $e');
      return null;
    }
  }

  bool _autorizacionDialogVisible = false;

  Future<void> _mostrarInformacionDeAutorizacion(
      Map<String, dynamic> autorizacionInfo) async {
    if (!_autorizacionDialogVisible) {
      _autorizacionDialogVisible = true;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Autorización Encontrada'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Código: ${autorizacionInfo["Codigo"]}'),
                Text('Entidad Origen: ${autorizacionInfo["Entidad_Origen"]}'),
                Text('Entidad Destino: ${autorizacionInfo["Entidad_Destino"]}'),
                Text('Cuenta Origen: ${autorizacionInfo["Cuenta_Origen"]}'),
                Text('Cuenta Destino: ${autorizacionInfo["Cuenta_Destino"]}'),
                Text(
                    'Identificación Origen: ${autorizacionInfo["identificacion_Origen"]}'),
                Text(
                    'Identificación Destino: ${autorizacionInfo["identificacion_Destino"]}'),
                Text('Fecha Inicio: ${autorizacionInfo["Fecha_Inicio"]}'),
                Text(
                    'Fecha Finalización: ${autorizacionInfo["Fecha_Finalizacion"]}'),
                Text('Estado: ${autorizacionInfo["Estado"]}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _autorizacionDialogVisible =
                      false; // Marcar como no visible al cerrar el diálogo
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _obtenerYMostrarAutorizacion() async {
    // Validar campos obligatorios
    if (_valueDrop.isEmpty ||
        _cuentaDestinoController.text.isEmpty ||
        _identificacionDestinoController.text.isEmpty) {
      print('Campos obligatorios incompletos');
      return;
    }

    // Obtener autorización desde el API
    final autorizacion = await _getAutorizacionVigente();

    if (autorizacion != null) {
      _mostrarInformacionDeAutorizacion(autorizacion);
    } else {
      _mostrarError('No se encontró ninguna autorización.');
    }
  }

  bool _errorDialogVisible = false;

  void _mostrarError(String mensaje) {
    if (!_errorDialogVisible) {
      _errorDialogVisible = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _errorDialogVisible =
                      false; // Marcar como no visible al cerrar el diálogo
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }
}
