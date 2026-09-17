import 'package:flutter_application_1/data/repositories/usuario_memoria.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('devuelve tres usuarios sin utilizar la red', () async {
    final usuarios = await UsuarioMemoria().obtener();

    expect(usuarios, hasLength(3));
    expect(usuarios.map((usuario) => usuario.nombre), [
      'Ana Torres',
      'Bruno Díaz',
      'Elena Vargas',
    ]);
  });
}
