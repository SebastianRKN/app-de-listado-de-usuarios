import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/usuario_memoria.dart';
import 'package:flutter_application_1/domain/usecases/obtener_usuarios_con_vocal.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra solamente los usuarios cuyo nombre empieza con vocal', (
    tester,
  ) async {
    final casoDeUso = ObtenerUsuariosConVocal(UsuarioMemoria());

    await tester.pumpWidget(MyApp(obtenerUsuariosConVocal: casoDeUso));
    await tester.pumpAndSettle();

    expect(find.text('Ana Torres'), findsOneWidget);
    expect(find.text('Elena Vargas'), findsOneWidget);
    expect(find.text('Bruno Díaz'), findsNothing);
    expect(find.text('2 nombres comienzan con una vocal'), findsOneWidget);
  });

  testWidgets('permite buscar dentro de los usuarios mostrados', (
    tester,
  ) async {
    final casoDeUso = ObtenerUsuariosConVocal(UsuarioMemoria());

    await tester.pumpWidget(MyApp(obtenerUsuariosConVocal: casoDeUso));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Buscar por nombre o correo'),
      'elena',
    );
    await tester.pump();

    expect(find.text('Elena Vargas'), findsOneWidget);
    expect(find.text('Ana Torres'), findsNothing);
    expect(find.text('Resultados de búsqueda'), findsOneWidget);
  });
}
