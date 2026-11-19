/// Significados de cada número (Módulo 6). Son convenciones de la tradición
/// Balliett-Jordan, no hallazgos.
library;

class Arquetipo {
  const Arquetipo({
    required this.numero,
    required this.nombre,
    required this.luz,
    required this.sombra,
    required this.palabraClave,
    required this.pregunta,
  });

  final int numero;
  final String nombre;
  final String luz;
  final String sombra;
  final String palabraClave;

  /// Pregunta de reflexión: el curso recomienda leer en preguntas, no en sentencias.
  final String pregunta;

  bool get esMaestro => numero > 9;
  String get etiqueta => switch (numero) { 11 => '11/2', 22 => '22/4', 33 => '33/6', _ => '$numero' };
}

const Map<int, Arquetipo> arquetipos = {
  1: Arquetipo(
    numero: 1,
    nombre: 'El líder / pionero',
    luz: 'Iniciativa, independencia, valentía',
    sombra: 'Egoísmo, impaciencia',
    palabraClave: 'Empezar',
    pregunta: '¿Qué te gustaría empezar si no esperaras el permiso de nadie?',
  ),
  2: Arquetipo(
    numero: 2,
    nombre: 'El mediador',
    luz: 'Cooperación, sensibilidad, diplomacia',
    sombra: 'Dependencia, indecisión',
    palabraClave: 'Unir',
    pregunta: '¿En qué relaciones cedes más de lo que quisieras?',
  ),
  3: Arquetipo(
    numero: 3,
    nombre: 'El comunicador',
    luz: 'Creatividad, expresión, alegría',
    sombra: 'Dispersión, superficialidad',
    palabraClave: 'Expresar',
    pregunta: '¿Qué tienes ganas de decir o crear y todavía no has expresado?',
  ),
  4: Arquetipo(
    numero: 4,
    nombre: 'El constructor',
    luz: 'Orden, disciplina, trabajo',
    sombra: 'Rigidez, terquedad',
    palabraClave: 'Estructurar',
    pregunta: '¿Dónde sientes que te falta estructura?',
  ),
  5: Arquetipo(
    numero: 5,
    nombre: 'El aventurero',
    luz: 'Libertad, cambio, versatilidad',
    sombra: 'Inquietud, excesos',
    palabraClave: 'Cambiar',
    pregunta: '¿Qué cambio estás evitando, y cuál estás forzando?',
  ),
  6: Arquetipo(
    numero: 6,
    nombre: 'El protector',
    luz: 'Responsabilidad, familia, servicio',
    sombra: 'Control, sacrificio excesivo',
    palabraClave: 'Cuidar',
    pregunta: '¿A quién cuidas, y quién te cuida a ti?',
  ),
  7: Arquetipo(
    numero: 7,
    nombre: 'El buscador',
    luz: 'Análisis, espiritualidad, introspección',
    sombra: 'Aislamiento, desconfianza',
    palabraClave: 'Comprender',
    pregunta: '¿Qué pregunta de tu vida te gustaría entender mejor?',
  ),
  8: Arquetipo(
    numero: 8,
    nombre: 'El ejecutivo',
    luz: 'Poder, logro material, autoridad',
    sombra: 'Materialismo, dominio',
    palabraClave: 'Lograr',
    pregunta: '¿Qué significa para ti tener éxito, y a qué precio lo quieres?',
  ),
  9: Arquetipo(
    numero: 9,
    nombre: 'El humanista',
    luz: 'Compasión, idealismo, cierre de ciclos',
    sombra: 'Resentimiento, dispersión emocional',
    palabraClave: 'Soltar',
    pregunta: '¿Qué etapa, idea o relación está pidiendo un cierre?',
  ),
  11: Arquetipo(
    numero: 11,
    nombre: 'El inspirador (maestro)',
    luz: 'Intuición, visión, iluminación',
    sombra: 'Ansiedad, tensión nerviosa',
    palabraClave: 'Inspirar',
    pregunta: '¿Cuándo confías en tu intuición y cuándo te paraliza la tensión?',
  ),
  22: Arquetipo(
    numero: 22,
    nombre: 'El maestro constructor',
    luz: 'Grandes obras, visión práctica',
    sombra: 'Presión, autoexigencia',
    palabraClave: 'Materializar',
    pregunta: '¿Qué proyecto grande quieres hacer real, y cuánta presión te pones?',
  ),
  33: Arquetipo(
    numero: 33,
    nombre: 'El maestro sanador',
    luz: 'Amor incondicional, enseñanza',
    sombra: 'Martirio, carga ajena',
    palabraClave: 'Sanar',
    pregunta: '¿Qué cargas que en realidad no te corresponde?',
  ),
};

/// El arquetipo de un número: los maestros tienen el suyo; el resto se reduce a 1–9.
Arquetipo? arquetipoDe(int n) {
  if (arquetipos.containsKey(n)) return arquetipos[n];
  if (n <= 0) return null;
  var r = n;
  while (r > 9) {
    r = r.toString().split('').fold(0, (s, c) => s + int.parse(c));
  }
  return arquetipos[r];
}

/// Números de deuda kármica: "lecciones pendientes".
const Map<int, String> deudasKarmicas = {
  13: 'Trabajar con constancia sin buscar atajos',
  14: 'Usar la libertad con moderación',
  16: 'Reconstruirse tras caídas del ego',
  19: 'Ser independiente sin abusar del poder',
};

/// El desafío 0 es el único número que no tiene arquetipo.
const String desafioCero =
    'Desafío 0: no hay un obstáculo concreto. El reto es elegir, entre todos los caminos, '
    'cuál trabajar.';

/// Qué dice representar cada número núcleo y cada ciclo (Módulo 5).
class DefinicionNumero {
  const DefinicionNumero(this.nombre, this.seCalculaCon, this.representa);
  final String nombre;
  final String seCalculaCon;
  final String representa;
}

const definiciones = {
  'Camino de Vida': DefinicionNumero(
      'Camino de Vida', 'Fecha completa', 'El rumbo y las lecciones de la vida. Es el número más importante.'),
  'Expresión': DefinicionNumero('Expresión (Destino)', 'Todas las letras del nombre', 'Talentos y forma de actuar'),
  'Impulso del Alma': DefinicionNumero(
      'Impulso del Alma (Deseo del Corazón)', 'Vocales del nombre', 'Lo que la persona desea por dentro'),
  'Personalidad': DefinicionNumero('Personalidad', 'Consonantes del nombre', 'Cómo la perciben los demás'),
  'Cumpleaños': DefinicionNumero('Cumpleaños', 'Día de nacimiento', 'Un talento específico'),
  'Madurez': DefinicionNumero(
      'Madurez', 'Camino de Vida + Expresión', 'La meta de la segunda mitad de la vida'),
  'Año Personal': DefinicionNumero('Año Personal', 'Mes + día de nacimiento + año en curso',
      'Un ciclo de 9 años: el 1 inicia, el 5 trae cambio, el 9 cierra'),
  'Mes Personal': DefinicionNumero('Mes Personal', 'Año Personal + mes en curso', 'El tono del mes'),
  'Día Personal': DefinicionNumero('Día Personal', 'Mes Personal + día en curso', 'El tono del día'),
  'Año Universal': DefinicionNumero('Año Universal', 'Solo el año en curso', 'El tono del año para todos'),
  'Pináculo': DefinicionNumero('Pináculo', 'Mes, día y año reducidos', 'Cada una de las cuatro grandes etapas de la vida'),
  'Desafío': DefinicionNumero('Desafío', 'Restas entre mes, día y año', 'El obstáculo asociado a cada etapa'),
};
