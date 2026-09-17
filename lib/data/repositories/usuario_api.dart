import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  static final Uri _url = Uri.parse(
    'https://jsonplaceholder.typicode.com/users',
  );

  Future<List<Usuario>>? _solicitud;

  @override
  Future<List<Usuario>> obtener() {
    return _solicitud ??= _obtenerDesdeApi();
  }

  Future<List<Usuario>> _obtenerDesdeApi() async {
    try {
      return await _descargarUsuarios();
    } catch (_) {
      _solicitud = null;
      rethrow;
    }
  }

  Future<List<Usuario>> _descargarUsuarios() async {
    final respuesta = await http.get(_url);

    if (respuesta.statusCode != 200) {
      throw Exception(
        'La API respondió con el código ${respuesta.statusCode}.',
      );
    }

    final datos = jsonDecode(respuesta.body) as List<dynamic>;

    return datos
        .map((dato) {
          final json = Map<String, dynamic>.from(dato as Map);
          return Usuario(
            id: json['id'] as int,
            nombre: json['name'] as String,
            email: json['email'] as String,
          );
        })
        .toList(growable: false);
  }
}
