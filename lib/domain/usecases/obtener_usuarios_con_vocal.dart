import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  const ObtenerUsuariosConVocal(this._repository);

  final UsuarioRepository _repository;

  Future<List<Usuario>> ejecutar() async {
    final usuarios = await _repository.obtener();

    return usuarios
        .where((usuario) {
          final nombre = usuario.nombre.trim();
          return nombre.isNotEmpty && 'AEIOU'.contains(nombre[0].toUpperCase());
        })
        .toList(growable: false);
  }
}
