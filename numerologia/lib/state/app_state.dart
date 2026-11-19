import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/carta.dart';
import '../core/letras.dart';

/// Estado de la app: personas guardadas y ajustes de cálculo, persistidos en el dispositivo.
class AppState extends ChangeNotifier {
  static const _clavePersonas = 'personas';
  static const _claveAjustes = 'ajustes';

  SharedPreferences? _prefs;
  List<Persona> _personas = [];
  Ajustes _ajustes = const Ajustes();
  bool cargado = false;

  List<Persona> get personas => List.unmodifiable(_personas);
  Ajustes get ajustes => _ajustes;

  Future<void> cargar() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final personas = _prefs!.getString(_clavePersonas);
      if (personas != null) {
        _personas = (jsonDecode(personas) as List)
            .map((e) => Persona.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      final ajustes = _prefs!.getString(_claveAjustes);
      if (ajustes != null) {
        _ajustes = Ajustes.fromJson(jsonDecode(ajustes) as Map<String, dynamic>);
      }
    } catch (_) {
      // Si el almacenamiento no está disponible, la app funciona en memoria.
    }
    cargado = true;
    notifyListeners();
  }

  Carta cartaDe(Persona p) => Carta.calcular(p, _ajustes);

  Persona? buscar(String id) {
    for (final p in _personas) {
      if (p.id == id) return p;
    }
    return null;
  }

  void guardarPersona(Persona persona) {
    final i = _personas.indexWhere((p) => p.id == persona.id);
    if (i >= 0) {
      _personas[i] = persona;
    } else {
      _personas.insert(0, persona);
    }
    _guardar();
  }

  void eliminarPersona(String id) {
    _personas.removeWhere((p) => p.id == id);
    _guardar();
  }

  void actualizarAjustes(Ajustes ajustes) {
    _ajustes = ajustes;
    _prefs?.setString(_claveAjustes, jsonEncode(ajustes.toJson()));
    notifyListeners();
  }

  void _guardar() {
    _prefs?.setString(_clavePersonas, jsonEncode(_personas.map((p) => p.toJson()).toList()));
    notifyListeners();
  }

  static String nuevoId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);
}

/// Da acceso al [AppState] desde cualquier widget y lo reconstruye al cambiar.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
