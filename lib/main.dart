import 'package:flutter/material.dart';

import 'data/repositories/usuario_api.dart';
import 'domain/usecases/obtener_usuarios.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/pantalla_usuarios.dart';

void main() {
  final repositorio = UsuarioApi();
  final obtenerUsuarios = ObtenerUsuarios(repositorio);
  final obtenerUsuariosConVocal = ObtenerUsuariosConVocal(repositorio);

  runApp(
    MyApp(
      obtenerUsuarios: obtenerUsuarios,
      obtenerUsuariosConVocal: obtenerUsuariosConVocal,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.obtenerUsuarios,
    required this.obtenerUsuariosConVocal,
    super.key,
  });

  final ObtenerUsuarios obtenerUsuarios;
  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  Widget build(BuildContext context) {
    final esquema = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B4BDB),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios con vocal',
      theme: ThemeData(
        colorScheme: esquema,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE7E8F0)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE7E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE7E8F0)),
          ),
        ),
      ),
      home: PantallaUsuarios(
        obtenerUsuarios: obtenerUsuarios,
        obtenerUsuariosConVocal: obtenerUsuariosConVocal,
      ),
    );
  }
}
