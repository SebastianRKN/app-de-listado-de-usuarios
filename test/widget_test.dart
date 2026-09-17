import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/usuario_memoria.dart';
import 'package:flutter_application_1/domain/usecases/obtener_usuarios.dart';
import 'package:flutter_application_1/domain/usecases/obtener_usuarios_con_vocal.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra solamente los usuarios cuyo nombre empieza con vocal', (
    tester,
  ) async {
    final casoDeUso = ObtenerUsuariosConVocal(UsuarioMemoria());
    final obtenerUsuarios = ObtenerUsuarios(UsuarioMemoria());

    await tester.pumpWidget(
      MyApp(
        obtenerUsuarios: obtenerUsuarios,
        obtenerUsuariosConVocal: casoDeUso,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ana Torres'), findsOneWidget);
    expect(find.text('Elena Vargas'), findsOneWidget);
    expect(find.text('Bruno Díaz'), findsNothing);
    expect(find.text('2 nombres comienzan con una vocal'), findsOneWidget);
  });

  testWidgets('permite buscar entre todos los usuarios del repositorio', (
    tester,
  ) async {
    final repositorio = UsuarioMemoria();
    final casoDeUso = ObtenerUsuariosConVocal(repositorio);
    final obtenerUsuarios = ObtenerUsuarios(repositorio);

    await tester.pumpWidget(
      MyApp(
        obtenerUsuarios: obtenerUsuarios,
        obtenerUsuariosConVocal: casoDeUso,
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(
        TextField,
        'Buscar entre todos los usuarios de la API',
      ),
      'bruno',
    );
    await tester.pump();

    expect(find.text('Bruno Díaz'), findsOneWidget);
    expect(find.text('Ana Torres'), findsNothing);
    expect(find.text('Resultados de búsqueda'), findsOneWidget);
  });
}
