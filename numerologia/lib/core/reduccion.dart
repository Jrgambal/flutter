/// Reducción teosófica: sumar los dígitos de un número hasta llegar a uno solo,
/// respetando los números maestros y anotando las deudas kármicas (Módulo 4).
library;

const Set<int> numerosMaestros = {11, 22, 33};
const Set<int> numerosKarmicos = {13, 14, 16, 19};

int sumaDigitos(int n) {
  var resto = n.abs();
  var suma = 0;
  while (resto > 0) {
    suma += resto % 10;
    resto ~/= 10;
  }
  return suma;
}

/// Resultado de reducir un número, con todos los pasos intermedios.
class Reduccion {
  const Reduccion(this.cadena);

  /// Pasos de la reducción: el primero es la suma bruta y el último el valor final.
  final List<int> cadena;

  int get bruto => cadena.first;
  int get valor => cadena.last;
  bool get esMaestro => numerosMaestros.contains(valor);

  /// El dígito base (11 → 2, 22 → 4, 33 → 6).
  int get base => valor > 9 ? reducirSimple(valor) : valor;

  /// 13, 14, 16 o 19 si aparece antes de la reducción final.
  int? get deudaKarmica {
    for (final n in cadena.take(cadena.length - 1)) {
      if (numerosKarmicos.contains(n)) return n;
    }
    return null;
  }

  /// Notación del curso: 11/2, 13/4, 8…
  String get etiqueta {
    if (esMaestro) return '$valor/$base';
    final deuda = deudaKarmica;
    if (deuda != null) return '$deuda/$valor';
    return '$valor';
  }

  /// Clave para buscar el significado: el maestro se conserva, el resto es 0–9.
  int get claveSignificado => valor;

  String get pasos => cadena.join(' → ');

  @override
  String toString() => etiqueta;
}

/// Reduce [n] hasta un dígito. Si [maestros] es verdadero, se detiene en 11, 22 o 33.
Reduccion reducir(int n, {bool maestros = true}) {
  final cadena = <int>[n];
  var actual = n;
  while (actual > 9 && !(maestros && numerosMaestros.contains(actual))) {
    actual = sumaDigitos(actual);
    cadena.add(actual);
  }
  return Reduccion(List.unmodifiable(cadena));
}

int reducirSimple(int n) => reducir(n, maestros: false).valor;
