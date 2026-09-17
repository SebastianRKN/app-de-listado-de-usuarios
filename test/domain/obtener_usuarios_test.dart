import 'package:flutter_application_1/data/repositories/usuario_memoria.dart';
import 'package:flutter_application_1/domain/usecases/obtener_usuarios.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('devuelve todos los usuarios sin aplicar el filtro por vocal', () async {
    final casoDeUso = ObtenerUsuarios(UsuarioMemoria());

    final resultado = await casoDeUso.ejecutar();

    expect(resultado, hasLength(3));
    expect(resultado.any((usuario) => usuario.nombre == 'Bruno Díaz'), isTrue);
  });
}
