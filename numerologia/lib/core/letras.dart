/// Tablas de letras y normalización del nombre (Módulo 3).
library;

/// Cómo tratar la Y: el curso señala que algunas escuelas la cuentan como
/// vocal cuando suena a "i".
enum ModoY {
  consonante('Siempre consonante'),
  vocal('Siempre vocal'),
  segunSonido('Vocal cuando suena a "i"');

  const ModoY(this.descripcion);
  final String descripcion;
}

/// Preferencias de cálculo ajustables por el usuario.
class Ajustes {
  const Ajustes({this.valorEnie = 5, this.modoY = ModoY.consonante});

  /// La Ñ vale 5 (como la N) o 6, según el autor.
  final int valorEnie;
  final ModoY modoY;

  Ajustes copyWith({int? valorEnie, ModoY? modoY}) =>
      Ajustes(valorEnie: valorEnie ?? this.valorEnie, modoY: modoY ?? this.modoY);

  Map<String, dynamic> toJson() => {'valorEnie': valorEnie, 'modoY': modoY.name};

  factory Ajustes.fromJson(Map<String, dynamic> json) => Ajustes(
        valorEnie: json['valorEnie'] as int? ?? 5,
        modoY: ModoY.values.firstWhere(
          (m) => m.name == json['modoY'],
          orElse: () => ModoY.consonante,
        ),
      );
}

const _sinAcento = {
  'Á': 'A', 'À': 'A', 'Â': 'A', 'Ä': 'A', 'Ã': 'A', //
  'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E', //
  'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I', //
  'Ó': 'O', 'Ò': 'O', 'Ô': 'O', 'Ö': 'O', 'Õ': 'O', //
  'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U', //
  'Ç': 'C',
};

const _vocales = {'A', 'E', 'I', 'O', 'U'};

/// Tabla caldea: valores del 1 al 8; el 9 no se asigna.
const Map<String, int> tablaCaldea = {
  'A': 1, 'I': 1, 'J': 1, 'Q': 1, 'Y': 1, //
  'B': 2, 'K': 2, 'R': 2, //
  'C': 3, 'G': 3, 'L': 3, 'S': 3, //
  'D': 4, 'M': 4, 'T': 4, //
  'E': 5, 'H': 5, 'N': 5, 'X': 5, 'Ñ': 5, //
  'U': 6, 'V': 6, 'W': 6, //
  'O': 7, 'Z': 7, //
  'F': 8, 'P': 8,
};

/// Pasa a mayúsculas, quita acentos (se ignoran) y conserva la Ñ.
String normalizarLetra(String c) {
  final mayuscula = c.toUpperCase();
  return _sinAcento[mayuscula] ?? mayuscula;
}

bool esLetraValida(String c) {
  if (c == 'Ñ') return true;
  final code = c.codeUnitAt(0);
  return c.length == 1 && code >= 65 && code <= 90;
}

/// Tabla pitagórica: A=1 … I=9, J=1 … R=9, S=1 … Z=8.
int valorPitagorico(String letra, Ajustes ajustes) {
  if (letra == 'Ñ') return ajustes.valorEnie;
  return (letra.codeUnitAt(0) - 65) % 9 + 1;
}

int valorCaldeo(String letra) => tablaCaldea[letra] ?? 0;

/// Una letra del nombre ya convertida.
class Letra {
  const Letra(this.caracter, this.valor, {required this.vocal});
  final String caracter;
  final int valor;
  final bool vocal;
}

/// Una palabra del nombre con sus letras.
class Palabra {
  const Palabra(this.texto, this.letras);
  final String texto;
  final List<Letra> letras;
}

/// Divide el nombre en palabras y convierte cada letra con la tabla pitagórica.
List<Palabra> analizarNombre(String nombre, Ajustes ajustes) {
  final palabras = <Palabra>[];
  for (final cruda in nombre.trim().split(RegExp(r'[\s\-]+'))) {
    final caracteres = cruda.split('').map(normalizarLetra).where(esLetraValida).toList();
    if (caracteres.isEmpty) continue;
    final letras = <Letra>[];
    for (var i = 0; i < caracteres.length; i++) {
      final c = caracteres[i];
      letras.add(Letra(
        c,
        valorPitagorico(c, ajustes),
        vocal: _esVocal(caracteres, i, ajustes.modoY),
      ));
    }
    palabras.add(Palabra(caracteres.join(), letras));
  }
  return palabras;
}

bool _esVocal(List<String> letras, int i, ModoY modoY) {
  final c = letras[i];
  if (_vocales.contains(c)) return true;
  if (c != 'Y') return false;
  switch (modoY) {
    case ModoY.consonante:
      return false;
    case ModoY.vocal:
      return true;
    case ModoY.segunSonido:
      // Suena a "i" cuando no va junto a otra vocal (Lyn, Ybarra), y como
      // consonante cuando acompaña a una (Yolanda, Rey).
      final antes = i > 0 && _vocales.contains(letras[i - 1]);
      final despues = i < letras.length - 1 && _vocales.contains(letras[i + 1]);
      return !antes && !despues;
  }
}
