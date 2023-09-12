import 'package:flutter/material.dart';
import 'package:flutter_proyecto3prograv/providers/login_provider.dart';
import 'package:flutter_proyecto3prograv/screens/login_screen.dart';
import 'package:provider/provider.dart';

class MenuDesplegable extends StatefulWidget {
  const MenuDesplegable();
  @override
  State<MenuDesplegable> createState() => _MenuDesplegableState();
}

class _MenuDesplegableState extends State<MenuDesplegable> {
  String nombreCliente = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    nombreCliente = Provider.of<loginProvider>(context, listen: false).nombreCliente;
    int num = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            _createHeader(),
            _createOption("autorización", 'autorización', Icons.abc_sharp),
            ///_createOption("Clientes", 'clientes', Icons.person_pin_rounded),
              _createOption(
                "Transferencias", 'transferencia', Icons.monetization_on),
            Expanded(child: Container()),
            _createLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _createIcon() {
    return Icon(
      Icons.person,
      size: 70,
      color: Colors.black,
    );
  }

  Widget _createHeader() {
    return UserAccountsDrawerHeader(
      accountName: nombreCliente != null
          ? Text(
              nombreCliente,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: _createIcon(),
      ),
      accountEmail: null,
      decoration: BoxDecoration(
        color: Colors
            .blue, // Puedes cambiar el color de fondo según tus necesidades
      ),
    );
  }

  Widget _createOption(String titulo, String ruta, icono) {
    return Builder(
      builder: (context) => ListTile(
        title: Text(titulo),
        leading: Icon(icono),
        onTap: () {
          Navigator.pushNamed(context, ruta);
        },
      ),
    );
  }

  Widget _createLogoutButton() {
    return ListTile(
      title: Text(
        "Cerrar sesión",
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      leading: Icon(Icons.logout),
      onTap: () => _cerrarSesion(context),
      tileColor: Colors.red,
      iconColor: Colors.white,
    );
  }

  void _cerrarSesion(BuildContext context) {
    context.read<loginProvider>().setdatosCliente("", "");
    // Cerrar sesión
    // Redireccionar a la pantalla de inicio de sesión (PantallaInicioSesion)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PantallaInicioSesion()),
    );
  }
}
