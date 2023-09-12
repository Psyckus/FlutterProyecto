import 'package:flutter/material.dart';
import 'package:flutter_proyecto3prograv/models/info_login.dart';
import 'package:flutter_proyecto3prograv/negocios/login_service.dart';
import 'package:flutter_proyecto3prograv/negocios/notificaciones.dart';
import 'package:flutter_proyecto3prograv/providers/respuesta_provider.dart';
import 'package:flutter_proyecto3prograv/screens/principal.dart';
import 'package:provider/provider.dart';


import '../providers/identificacion_provider.dart';
class PantallaInicioSesion extends StatefulWidget {
  @override
  _PantallaInicioSesionState createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  // Create TextEditingController for the username and password fields
  final TextEditingController _controladorusername = TextEditingController();
  final TextEditingController _controladorpassword = TextEditingController();
  final TextEditingController _controladornombreCliente =
      TextEditingController();

  bool _usernameError = false;
  bool _passwordError = false;
  bool _showpassword = false; // New state for showing password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Pantalla de Inicio de Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _crearTextBox(
              "Username",
              _controladorusername,
              _isValidUsername,
              _usernameError,
              "Solo se permiten números y letras",
            ),
            SizedBox(height: 16.0),
            _crearTextBox(
              "Password",
              _controladorpassword,
              _isValidPassword,
              _passwordError,
              "Este campo no puede quedar en blanco",
              obscureText: !_showpassword,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Mostrar contraseña"),
                Checkbox(
                  value: _showpassword,
                  onChanged: (value) {
                    setState(() {
                      _showpassword = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _usernameError = !_isValidUsername(_controladorusername.text);
                  _passwordError = !_isValidPassword(_controladorpassword.text);
                });

                if (!_usernameError && !_passwordError) {
                  iniciarSesion();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Usuario y/o contraseña incorrectos.')),
                  );
                }
              },
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidUsername(String value) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }

  bool _isValidPassword(String value) {
    return value.isNotEmpty;
  }

  Widget _crearTextBox(String placeholder, TextEditingController controller,
      bool Function(String) validator, bool error, String errorMessage,
      {bool obscureText = false}) {
    return Container(
      height: 75.0,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
          errorText: error ? errorMessage : null,
        ),
      ),
    );
  }

  Future<void> iniciarSesion() async {
    var login = Login();
    String username = _controladorusername.text;
    login
      ..username = _controladorusername.text
      ..password = _controladorpassword.text
      ..nombreCliente = _controladornombreCliente.text;
    //var errores = await LoginService.iniciarlogin(login, context);

    String nombreCliente = await LoginService.iniciarlogin(login, context);

    if (nombreCliente != null) {
      Provider.of<IdentificacionProvider>(context, listen: false)
          .setNumeroIdentificacion(username);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Principal(nombreCliente)),
      );
    } else {
      var respuesta =
          Provider.of<RespuestaProvider>(context, listen: false).mensaje;
      Alertas.notificacion(respuesta, context);
    }
  }
}
