import 'package:flutter_application_1/domain/entities/usuario.dart';
import 'package:flutter_application_1/domain/repositories/usuario_repository.dart';
import 'package:flutter_application_1/domain/usecases/obtener_usuarios_con_vocal.dart';
import 'package:flutter_test/flutter_test.dart';

class _RepositorioFalso implements UsuarioRepository {
  @override
  Future<List<Usuario>> obtener() async => const [
    Usuario(id: 1, nombre: 'Ana', email: 'ana@example.com'),
    Usuario(id: 2, nombre: 'bruno', email: 'bruno@example.com'),
    Usuario(id: 3, nombre: ' elena', email: 'elena@example.com'),
    Usuario(id: 4, nombre: '', email: 'sin-nombre@example.com'),
  ];
}

void main() {
  test('devuelve solo usuarios cuyo nombre empieza con vocal', () async {
    final casoDeUso = ObtenerUsuariosConVocal(_RepositorioFalso());

    final resultado = await casoDeUso.ejecutar();

    expect(resultado.map((usuario) => usuario.nombre), ['Ana', ' elena']);
  });
}
