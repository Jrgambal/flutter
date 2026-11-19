/// La carta numerológica completa: números núcleo, ciclos y extras (Módulos 4 y 5).
library;

import 'letras.dart';
import 'reduccion.dart';

/// Una persona guardada en la app.
class Persona {
  const Persona({
    required this.id,
    required this.nombre,
    required this.nacimiento,
    this.nombreUso,
  });

  final String id;

  /// Nombre completo de nacimiento.
  final String nombre;

  /// Nombre de uso diario (opcional; lo usa el sistema caldeo).
  final String? nombreUso;
  final DateTime nacimiento;

  Persona copyWith({String? nombre, String? nombreUso, DateTime? nacimiento}) => Persona(
        id: id,
        nombre: nombre ?? this.nombre,
        nombreUso: nombreUso ?? this.nombreUso,
        nacimiento: nacimiento ?? this.nacimiento,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'nombreUso': nombreUso,
        'nacimiento': nacimiento.toIso8601String().substring(0, 10),
      };

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        nombreUso: json['nombreUso'] as String?,
        nacimiento: DateTime.parse(json['nacimiento'] as String),
      );
}

/// Desglose de una palabra para un número del nombre.
class DetallePalabra {
  const DetallePalabra(this.palabra, this.letras, this.reduccion);
  final String palabra;
  final List<Letra> letras;
  final Reduccion reduccion;
  int get suma => reduccion.bruto;
}

/// Un número sacado del nombre: cada palabra se reduce por separado y luego se suman.
class NumeroNombre {
  const NumeroNombre(this.palabras, this.reduccion, this.sumaDirecta);

  final List<DetallePalabra> palabras;

  /// Suma de las palabras reducidas, y su reducción.
  final Reduccion reduccion;

  /// Suma de todas las letras sin reducir por palabra (sirve de comprobación).
  final int sumaDirecta;

  factory NumeroNombre.calcular(List<Palabra> palabras, bool Function(Letra) filtro) {
    final detalles = <DetallePalabra>[];
    var total = 0;
    var directa = 0;
    for (final p in palabras) {
      final letras = p.letras.where(filtro).toList();
      if (letras.isEmpty) continue;
      final suma = letras.fold<int>(0, (s, l) => s + l.valor);
      final r = reducir(suma);
      detalles.add(DetallePalabra(p.texto, letras, r));
      total += r.valor;
      directa += suma;
    }
    return NumeroNombre(detalles, reducir(total), directa);
  }
}

class Pinaculo {
  const Pinaculo(this.numero, this.formula, this.desde, this.hasta);
  final Reduccion numero;
  final String formula;
  final int desde;

  /// Edad final de la etapa; null en la última.
  final int? hasta;

  String get edades => hasta == null ? '$desde en adelante' : '$desde–$hasta';
  bool contiene(int edad) => edad >= desde && (hasta == null || edad <= hasta!);
}

class Desafio {
  const Desafio(this.nombre, this.formula, this.valor);
  final String nombre;
  final String formula;
  final int valor;
}

/// Plano de expresión: agrupa las letras del nombre por su número.
class Plano {
  const Plano(this.nombre, this.numeros, this.cantidad);
  final String nombre;
  final List<int> numeros;
  final int cantidad;
}

class Puente {
  const Puente(this.entre, this.valor);
  final String entre;
  final int valor;
}

class Carta {
  Carta._({
    required this.persona,
    required this.ajustes,
    required this.palabras,
    required this.mes,
    required this.dia,
    required this.ano,
    required this.caminoVida,
    required this.expresion,
    required this.alma,
    required this.personalidad,
    required this.cumpleanos,
    required this.madurez,
    required this.inclusion,
    required this.caldeoCompuesto,
    required this.caldeo,
  });

  factory Carta.calcular(Persona persona, Ajustes ajustes) {
    final palabras = analizarNombre(persona.nombre, ajustes);
    final f = persona.nacimiento;
    final mes = reducir(f.month);
    final dia = reducir(f.day);
    final ano = reducir(f.year);
    final caminoVida = reducir(mes.valor + dia.valor + ano.valor);
    final expresion = NumeroNombre.calcular(palabras, (_) => true);
    final alma = NumeroNombre.calcular(palabras, (l) => l.vocal);
    final personalidad = NumeroNombre.calcular(palabras, (l) => !l.vocal);

    final inclusion = List<int>.filled(10, 0);
    for (final p in palabras) {
      for (final l in p.letras) {
        inclusion[l.valor]++;
      }
    }

    final uso = (persona.nombreUso?.trim().isNotEmpty ?? false) ? persona.nombreUso! : persona.nombre;
    var compuesto = 0;
    for (final c in uso.split('')) {
      compuesto += valorCaldeo(normalizarLetra(c));
    }

    return Carta._(
      persona: persona,
      ajustes: ajustes,
      palabras: palabras,
      mes: mes,
      dia: dia,
      ano: ano,
      caminoVida: caminoVida,
      expresion: expresion,
      alma: alma,
      personalidad: personalidad,
      cumpleanos: dia,
      madurez: reducir(caminoVida.valor + expresion.reduccion.valor),
      inclusion: List.unmodifiable(inclusion),
      caldeoCompuesto: compuesto,
      caldeo: reducir(compuesto),
    );
  }

  final Persona persona;
  final Ajustes ajustes;
  final List<Palabra> palabras;

  // Fecha reducida por partes.
  final Reduccion mes;
  final Reduccion dia;
  final Reduccion ano;

  // Los seis números núcleo.
  final Reduccion caminoVida;
  final NumeroNombre expresion;
  final NumeroNombre alma;
  final NumeroNombre personalidad;
  final Reduccion cumpleanos;
  final Reduccion madurez;

  /// Cuántas veces aparece cada número (índices 1–9) en el nombre.
  final List<int> inclusion;

  /// Sistema caldeo: número compuesto y su reducción.
  final int caldeoCompuesto;
  final Reduccion caldeo;

  bool get nombreValido => palabras.isNotEmpty;

  // ---------- Ciclos de tiempo ----------

  static Reduccion anoUniversal(int ano) => reducir(ano, maestros: false);

  /// Mes + día de nacimiento + año en curso; ciclo de 9 años.
  Reduccion anoPersonal(int anoEnCurso) =>
      reducir(mes.valor + dia.valor + anoUniversal(anoEnCurso).valor, maestros: false);

  Reduccion mesPersonal(DateTime fecha) =>
      reducir(anoPersonal(fecha.year).valor + fecha.month, maestros: false);

  Reduccion diaPersonal(DateTime fecha) =>
      reducir(mesPersonal(fecha).valor + fecha.day, maestros: false);

  int edadEn(DateTime fecha) {
    final n = persona.nacimiento;
    var edad = fecha.year - n.year;
    if (fecha.month < n.month || (fecha.month == n.month && fecha.day < n.day)) edad--;
    return edad;
  }

  // ---------- Pináculos y desafíos (usan M, D y A reducidos a un dígito) ----------

  int get _m => mes.base;
  int get _d => dia.base;
  int get _a => ano.base;

  /// El primer pináculo termina a los 36 − Camino de Vida; los dos siguientes duran 9 años.
  int get finPrimerPinaculo => 36 - caminoVida.base;

  List<Pinaculo> get pinaculos {
    final p1 = reducir(_m + _d);
    final p2 = reducir(_d + _a);
    final p3 = reducir(p1.valor + p2.valor);
    final p4 = reducir(_m + _a);
    final fin = finPrimerPinaculo;
    return [
      Pinaculo(p1, 'M + D = $_m + $_d', 0, fin),
      Pinaculo(p2, 'D + A = $_d + $_a', fin + 1, fin + 9),
      Pinaculo(p3, '1.º + 2.º = ${p1.valor} + ${p2.valor}', fin + 10, fin + 18),
      Pinaculo(p4, 'M + A = $_m + $_a', fin + 19, null),
    ];
  }

  int indicePinaculoActivo(DateTime fecha) {
    final edad = edadEn(fecha);
    final lista = pinaculos;
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].contiene(edad)) return i;
    }
    return 0;
  }

  /// Se restan en lugar de sumarse: es el único lugar donde aparece el 0.
  List<Desafio> get desafios {
    final d1 = (_m - _d).abs();
    final d2 = (_d - _a).abs();
    return [
      Desafio('1.º desafío', '|M − D| = |$_m − $_d|', d1),
      Desafio('2.º desafío', '|D − A| = |$_d − $_a|', d2),
      Desafio('Desafío principal', '|1.º − 2.º| = |$d1 − $d2|', (d1 - d2).abs()),
      Desafio('4.º desafío', '|M − A| = |$_m − $_a|', (_m - _a).abs()),
    ];
  }

  // ---------- Extras ----------

  /// Números que no aparecen en el nombre: "lecciones kármicas".
  List<int> get leccionesKarmicas => [for (var n = 1; n <= 9; n++) if (inclusion[n] == 0) n];

  /// Números que aparecen más veces que el promedio (dominantes en el nombre).
  List<int> get numerosIntensos {
    final total = inclusion.fold<int>(0, (s, n) => s + n);
    if (total == 0) return [];
    final maximo = inclusion.reduce((a, b) => a > b ? a : b);
    return [for (var n = 1; n <= 9; n++) if (inclusion[n] == maximo) n];
  }

  List<Plano> get planos {
    int contar(List<int> nums) => nums.fold(0, (s, n) => s + inclusion[n]);
    const grupos = {
      'Físico': [4, 5],
      'Mental': [1, 8],
      'Emocional': [2, 3, 6],
      'Intuitivo': [7, 9],
    };
    return [for (final e in grupos.entries) Plano(e.key, e.value, contar(e.value))];
  }

  List<Puente> get puentes => [
        Puente('Alma − Personalidad', (alma.reduccion.base - personalidad.reduccion.base).abs()),
        Puente('Camino de Vida − Expresión', (caminoVida.base - expresion.reduccion.base).abs()),
      ];

  /// Números núcleo con nombre, para buscar repeticiones.
  Map<String, Reduccion> get nucleo => {
        'Camino de Vida': caminoVida,
        'Expresión': expresion.reduccion,
        'Impulso del Alma': alma.reduccion,
        'Personalidad': personalidad.reduccion,
        'Cumpleaños': cumpleanos,
        'Madurez': madurez,
      };

  /// Números que se repiten entre los núcleo (por su dígito base).
  Map<int, List<String>> get repeticiones {
    final mapa = <int, List<String>>{};
    nucleo.forEach((nombre, r) => mapa.putIfAbsent(r.base, () => []).add(nombre));
    mapa.removeWhere((_, v) => v.length < 2);
    return mapa;
  }

  /// Deudas kármicas presentes en los números núcleo.
  Map<String, int> get deudas {
    final mapa = <String, int>{};
    nucleo.forEach((nombre, r) {
      final d = r.deudaKarmica;
      if (d != null) mapa[nombre] = d;
    });
    return mapa;
  }
}
