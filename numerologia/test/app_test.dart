import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numerologia/main.dart';
import 'package:numerologia/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('el ejemplo del curso abre una carta con Camino de Vida 13/4', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('es');
    final state = AppState();
    await state.cargar();
    await tester.pumpWidget(NumerologiaApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Ver el ejemplo del curso'));
    await tester.pumpAndSettle();

    expect(find.text('Ana María López Ruiz'), findsOneWidget);
    expect(find.text('13/4'), findsOneWidget);
    expect(find.text('14/5'), findsOneWidget);

    await tester.tap(find.text('Lectura'));
    await tester.pumpAndSettle();
    expect(find.textContaining('0.º pináculo'), findsNothing);
  });

  testWidgets('compatibilidad entre dos personas guardadas', (tester) async {
    SharedPreferences.setMockInitialValues({
      'flutter.personas': '[{"id":"a","nombre":"Ana María López Ruiz","nacimiento":"1990-07-14"},'
          '{"id":"b","nombre":"Luis Pérez","nacimiento":"1987-11-29"}]',
    });
    await initializeDateFormatting('es');
    final state = AppState();
    await state.cargar();
    await tester.pumpWidget(NumerologiaApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Compatibilidad'));
    await tester.pumpAndSettle();

    expect(find.text('Número de la relación'), findsOneWidget);
    expect(find.textContaining('4 + 11 = 15 → 6'), findsOneWidget);
  });
}
