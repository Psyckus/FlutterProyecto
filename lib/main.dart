import 'package:flutter/material.dart';
import 'package:flutter_proyecto3prograv/providers/identificacion_provider.dart';
import 'package:flutter_proyecto3prograv/providers/login_provider.dart';
import 'package:flutter_proyecto3prograv/providers/producto_provider.dart';
import 'package:flutter_proyecto3prograv/providers/respuesta_provider.dart';
import 'package:flutter_proyecto3prograv/screens/autorizaciones_screen.dart';
import 'package:flutter_proyecto3prograv/screens/login_screen.dart';
import 'package:flutter_proyecto3prograv/screens/menu_desplegable.dart';
import 'package:flutter_proyecto3prograv/screens/principal.dart';
import 'package:flutter_proyecto3prograv/screens/transferencias_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductoProvider()),
      ChangeNotifierProvider(create: (_) => RespuestaProvider()),
      ChangeNotifierProvider(create: (_) => loginProvider()),
      ChangeNotifierProvider(create: (_) => IdentificacionProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tienda',
      initialRoute: '/',
      routes: {
        '/': (_) => PantallaInicioSesion(),
        'principal': (_) => Principal(""),
        'autorización': (_) => Registrarautorizacion(),
        'transferencia': (_) => transferencias(),
      }, 
      
      builder: (context, child) {
        // Agrega el menú desplegable a todas las páginas
        return Scaffold(
          drawer: MenuDesplegable(),
          body: child,
        );
      },
    );
  }
}
