import 'package:flutter/material.dart';
import 'package:flutter_proyecto3prograv/screens/menu_desplegable.dart';

class Principal extends StatefulWidget {
  final String nombreCliente;
  Principal(this.nombreCliente);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: _createBody(),
      drawer: MenuDesplegable(),
    );
  }

  Widget _createAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text("UnidadesR2"),
    );
  }

  Widget _createBody() {
    // Cuerpo de la aplicación
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Agregar la imagen estática
          Image.asset(
            'assets/images/logobanco1.png', // Reemplaza 'imagen_ejemplo.png' con el nombre de tu imagen
            width: 200, // Ancho deseado de la imagen
            height: 200, // Alto deseado de la imagen
          ),
          SizedBox(height: 20),
          Text('Bienvenido, ${widget.nombreCliente}'),
        ],
      ),
    );
  }
}
