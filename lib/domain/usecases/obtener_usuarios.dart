import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuarios {
  const ObtenerUsuarios(this._repository);

  final UsuarioRepository _repository;

  Future<List<Usuario>> ejecutar() => _repository.obtener();
}
