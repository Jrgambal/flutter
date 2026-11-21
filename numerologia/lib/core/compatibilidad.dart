/// Comparación numerológica entre dos personas.
///
/// El curso no define un método de compatibilidad, así que se construye con sus
/// propias herramientas: números puente (diferencias), reducción de sumas y la
/// convención habitual de "familias" de números. A propósito no hay puntuación
/// ni etiqueta de "incompatible": el Módulo 8 desaconseja descartar personas
/// por su número.
library;

import 'carta.dart';
import 'reduccion.dart';

/// Familias de números según la convención más extendida en los libros de práctica.
enum Familia {
  mental('Mentales', [1, 5, 7], 'independencia, curiosidad y libertad'),
  practica('Prácticos', [2, 4, 8], 'estabilidad, estructura y logro'),
  creativa('Creativos', [3, 6, 9], 'expresión, emoción y servicio');

  const Familia(this.nombre, this.numeros, this.valora);
  final String nombre;
  final List<int> numeros;
  final String valora;

  static Familia de(int base) => values.firstWhere((f) => f.numeros.contains(base));
}

enum TipoAfinidad {
  espejo('Espejo', 'Comparten el mismo número: se entienden rápido y también comparten la misma sombra.'),
  natural('Afinidad natural', 'Pertenecen a la misma familia: valoran cosas parecidas.'),
  complementaria('Complementarios',
      'Familias distintas: cada uno aporta lo que al otro le falta, y les toca traducir sus prioridades.');

  const TipoAfinidad(this.nombre, this.descripcion);
  final String nombre;
  final String descripcion;
}

/// Un mismo número núcleo comparado entre las dos personas.
class ComparacionNumero {
  const ComparacionNumero(this.nombre, this.a, this.b);

  final String nombre;
  final Reduccion a;
  final Reduccion b;

  Familia get familiaA => Familia.de(a.base);
  Familia get familiaB => Familia.de(b.base);

  /// Número puente: la diferencia entre ambos, "lo que ayuda a acercarlos".
  int get puente => (a.base - b.base).abs();

  TipoAfinidad get tipo {
    if (a.base == b.base) return TipoAfinidad.espejo;
    if (familiaA == familiaB) return TipoAfinidad.natural;
    return TipoAfinidad.complementaria;
  }
}

/// Lo que una persona desea (Alma) frente a lo que la otra muestra (Personalidad).
class Cruce {
  const Cruce(this.quienDesea, this.alma, this.quienMuestra, this.personalidad);
  final String quienDesea;
  final Reduccion alma;
  final String quienMuestra;
  final Reduccion personalidad;
  int get puente => (alma.base - personalidad.base).abs();
}

class Compatibilidad {
  Compatibilidad(this.a, this.b);

  final Carta a;
  final Carta b;

  String get nombreA => _primerNombre(a);
  String get nombreB => _primerNombre(b);

  static String _primerNombre(Carta c) {
    final uso = c.persona.nombreUso?.trim();
    if (uso != null && uso.isNotEmpty) return uso;
    return c.persona.nombre.split(RegExp(r'\s+')).first;
  }

  List<ComparacionNumero> get comparaciones => [
        ComparacionNumero('Camino de Vida', a.caminoVida, b.caminoVida),
        ComparacionNumero('Expresión', a.expresion.reduccion, b.expresion.reduccion),
        ComparacionNumero('Impulso del Alma', a.alma.reduccion, b.alma.reduccion),
        ComparacionNumero('Personalidad', a.personalidad.reduccion, b.personalidad.reduccion),
      ];

  /// Número de la relación: suma de los dos Caminos de Vida, respetando maestros.
  Reduccion get numeroRelacion => reducir(a.caminoVida.valor + b.caminoVida.valor);

  /// Alma de cada uno frente a la Personalidad del otro.
  List<Cruce> get cruces => [
        Cruce(nombreA, a.alma.reduccion, nombreB, b.personalidad.reduccion),
        Cruce(nombreB, b.alma.reduccion, nombreA, a.personalidad.reduccion),
      ];

  /// Años personales de ambos en [ano]; si coinciden, recorren el ciclo al mismo ritmo.
  (Reduccion, Reduccion) anosPersonales(int ano) => (a.anoPersonal(ano), b.anoPersonal(ano));

  int cuantos(TipoAfinidad tipo) => comparaciones.where((c) => c.tipo == tipo).length;
}
