import 'package:flutter/material.dart';
import 'package:flutter_proyecto3prograv/models/info_autorizaciones.dart';
import 'package:flutter_proyecto3prograv/negocios/autorizaciones_service.dart';
import 'package:flutter_proyecto3prograv/negocios/notificaciones.dart';
import 'package:flutter_proyecto3prograv/providers/login_provider.dart';
import 'package:flutter_proyecto3prograv/providers/respuesta_provider.dart';
import 'package:flutter_proyecto3prograv/screens/menu_desplegable.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../models/info_cuentaxcliente.dart';

class Registrarautorizacion extends StatefulWidget {
  const Registrarautorizacion();

  @override
  State<Registrarautorizacion> createState() => _Registrarautorizacion();
}

class _Registrarautorizacion extends State<Registrarautorizacion> {
  final _inicioFecha = DateTime(1950, 1);
  final _finalFecha = DateTime(2025, 12);
  final _diaHoy = DateTime.now();
  DateTime _fechaSeleccionada;

  List<String> _dataList = []; // Add this variable to store the data list
  Future<List<InfoCuentaxcliente>> _cuentaCliente;
  String _valueDrop = ""; //Variable para guardar el value del drop
  bool _guardando = false;
  String _selectedName = ''; // Add this variable to store the selected value
  bool _cargarModal = false;  
  //final _codigoController = TextEditingController();
  final _entidadOrigenController = TextEditingController();
  final _entidadDestinoController = TextEditingController();
  final _cuentaOrigenController = TextEditingController();
  final _cuentaDestinoController = TextEditingController();
  final _clienteAutorizaController = TextEditingController();
  final _clienteSolicitaController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinalizacionController = TextEditingController();
  //final _estadoController = TextEditingController();


Widget _crearCampoTextoConCalendario(
      String placeholder, TextEditingController controller) {
    return Container(
      height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        controller: controller,
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
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime selectedDate = await showDatePicker(
                context: context,
                initialDate: _diaHoy,
                firstDate: _inicioFecha,
                lastDate: _finalFecha,
              );
              if (selectedDate != null && selectedDate != _fechaSeleccionada) {
                setState(() {
                  _fechaSeleccionada = selectedDate;
                  controller.text =
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                });
              }
            },
          ),
        ),
      ),
    );
  }
  
  
  @override
  void initState() {
    super.initState();
    _init();
  }
  
  void _init() async {
    var respuesta = Provider.of<loginProvider>(context, listen: false).username;
    //_codigo = Provider.of<ProductoProvider>(context, listen: false).codigo;
    _cuentaCliente = AutorizacionesService.getCuentaXcliente(respuesta);
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
      drawer: MenuDesplegable(),
    );
  }

  Widget _crearAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text("Autorizaciones"),
    );
  }

  Widget _crearCuerpo() {
    return ModalProgressHUD(
      inAsyncCall: _guardando,
      child: _crearFormulario(),
    );
  }

  Widget _crearFormulario() {
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearDropdown("Seleccione una cuenta",_dataList),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTexto("Número de cuenta de origen de los fondos", _entidadDestinoController),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTexto("Identificación del cliente que autoriza", _clienteAutorizaController),
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTextoConCalendario("Fecha Inicio", _fechaInicioController), 
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearCampoTextoConCalendario("Fecha Finalización", _fechaFinalizacionController), 
            SizedBox(height: 20),
            SizedBox(height: 5),
            _crearBoton("Registrar", 20, 12),
          ],
        ),
      ],
    );
  }

  Widget _crearCampoTexto(String placeholder, TextEditingController controller) {
    return Container(
      height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
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



Widget _crearDropdown(String placeholder,List<String> dataList){
  List listName = ['juan','pedro','Maria'];
  return Container(
      height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: DropdownButtonFormField(
          items: dataList.map((name) {
            return DropdownMenuItem(
              child: Text(name),
              value: name,
            );
          }).toList(),
          onChanged: (value){
            _valueDrop = value;
            print(value);
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

  Widget _crearBoton(String infoMostrar, double valorHorizontal, double valorVertical) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _guardando = true;
        });
        registrarProducto();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: valorHorizontal, vertical: valorVertical),
        child: Text(infoMostrar),
      ),
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  // Método para registrar un producto
  Future<void> registrarProducto() async {
    String entidadDestino = _entidadDestinoController.text.substring(0, 3);
    var autorizacion = Autorizaciones();

    autorizacion
      //..codigo = _codigoController.text
      ..entidadOrigen = '001'
      ..entidadDestino = entidadDestino
      ..cuentaOrigen = _valueDrop
      ..cuentaDestino = _entidadDestinoController.text
      ..identificacionOrigen = _clienteAutorizaController.text //Cambiar por la persona que esta autentificada
      ..identificacionDestino = _clienteAutorizaController.text
      ..fechaInicio = _fechaInicioController.text.toString()
      ..fechaFinalizacion = _fechaFinalizacionController.text.toString()
      ..estado =  "Pendiente de autorizar";

    var errores = await AutorizacionesService.crearAutorizacion(autorizacion, context);

    setState(() {
      _guardando = false;
    });

    if (errores) {
      var respuesta = Provider.of<RespuestaProvider>(context, listen: false).mensaje;
      Alertas.notificacion(respuesta, context);
    } else {
      var respuesta = Provider.of<RespuestaProvider>(context, listen: false).mensaje;
      Alertas.notificacion(respuesta, context);
    }
  }
}


