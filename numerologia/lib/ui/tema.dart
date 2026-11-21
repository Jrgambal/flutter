import 'package:material_ui/material_ui.dart';

const _semilla = Color(0xFF4B2A8A);
const dorado = Color(0xFFD4A84A);

ThemeData _tema(Brightness brillo) {
  final esquema = ColorScheme.fromSeed(
    seedColor: _semilla,
    brightness: brillo,
    tertiary: brillo == Brightness.dark ? dorado : const Color(0xFF8A6512),
  );
  return ThemeData(
    colorScheme: esquema,
    useMaterial3: true,
    cardTheme: CardThemeData(
      elevation: 0,
      color: esquema.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(backgroundColor: esquema.surface, scrolledUnderElevation: 0),
  );
}

final temaClaro = _tema(Brightness.light);
final temaOscuro = _tema(Brightness.dark);
