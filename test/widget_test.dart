import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('muestra el título y el estado de carga inicial', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Usuarios con vocal'), findsOneWidget);
    expect(find.text('Cargando usuarios...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
