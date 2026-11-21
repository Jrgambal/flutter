/// Contenido del "Curso de Numerología: qué es, cómo funciona y qué dice la evidencia".
library;

sealed class Bloque {
  const Bloque();
}

class Parrafo extends Bloque {
  const Parrafo(this.texto, {this.titulo});
  final String? titulo;
  final String texto;
}

class Subtitulo extends Bloque {
  const Subtitulo(this.texto);
  final String texto;
}

class Vinetas extends Bloque {
  const Vinetas(this.items, {this.numeradas = false});
  final List<String> items;
  final bool numeradas;
}

class Tabla extends Bloque {
  const Tabla(this.encabezados, this.filas);
  final List<String> encabezados;
  final List<List<String>> filas;
}

class Destacado extends Bloque {
  const Destacado(this.texto, {this.critico = false});
  final String texto;

  /// Verdadero para las notas de "mirada crítica".
  final bool critico;
}

class Modulo {
  const Modulo(this.numero, this.titulo, this.resumen, this.bloques);
  final int numero;
  final String titulo;
  final String resumen;
  final List<Bloque> bloques;
}

const presentacion =
    'Numerología completa en 10 módulos: cómo se calcula una carta, qué significa cada número, '
    'de dónde viene y qué dice la ciencia sobre ella. Aprendemos el sistema "desde adentro" '
    '(como lo enseña un numerólogo) y lo evaluamos "desde afuera" (como lo analiza un '
    'científico o un historiador).';

const modulos = <Modulo>[
  Modulo(1, 'Qué es y qué tipo de disciplina es',
      'Un lenguaje de símbolos para hablar de uno mismo, no un instrumento de medición.', [
    Parrafo(
        'La numerología es la creencia de que los números tienen una relación mística con las personas '
        'y los hechos, y de que convertir un nombre o una fecha de nacimiento en números revela carácter '
        'y destino. Antes del siglo XX se llamaba aritmancia; la palabra "numerología" no aparece en '
        'inglés antes de 1907.'),
    Parrafo(
        'No es una ciencia. La comunidad científica la clasifica como pseudociencia: usa el lenguaje de '
        'los números para darse apariencia de rigor, pero sus afirmaciones no se pueden comprobar ni han '
        'superado pruebas controladas. La forma más precisa de definirla es como sistema '
        'simbólico-adivinatorio, de la misma familia que la astrología y el tarot.',
        titulo: 'Qué tipo de disciplina es'),
    Subtitulo('Tres cosas que se confunden'),
    Tabla([
      'Disciplina',
      'Qué hace',
      '¿Es ciencia?'
    ], [
      ['Matemática / teoría de números', 'Estudia propiedades demostrables de los números', 'Sí, ciencia formal'],
      ['Numerología', 'Asigna significados de personalidad y destino a números de nombres y fechas', 'No, sistema simbólico'],
      ['Simbolismo religioso (gematría)', 'Interpreta textos sagrados por el valor de las letras', 'No; exégesis religiosa'],
    ]),
    Subtitulo('La premisa central'),
    Vinetas([
      'Cada letra equivale a un número (según una tabla).',
      'Se suman los valores y se reducen a un dígito del 1 al 9 (o a un maestro: 11, 22, 33).',
      'Cada dígito tiene una "vibración" o arquetipo fijo.',
      'Ese arquetipo describe a la persona y los ciclos de su vida.',
    ], numeradas: true),
    Destacado(
        'El paso 3 es el que no tiene respaldo: no existe un mecanismo conocido por el que una suma de '
        'letras influya en una persona. El resto es aritmética simple.',
        critico: true),
  ]),
  Modulo(2, 'Historia: de Pitágoras al siglo XXI',
      'La numerología de hoy es un invento estadounidense de hace poco más de 100 años.', [
    Parrafo(
        'La idea de que los números tienen alma es antigua, pero la numerología que se practica hoy '
        '(Camino de Vida, Expresión, números maestros) es un invento estadounidense. Pitágoras no creó '
        'el sistema que lleva su nombre.'),
    Tabla([
      'Época',
      'Hito'
    ], [
      ['Siglo VIII a. C.', 'Sargón II construye una muralla de 16.283 codos, el valor numérico de su nombre'],
      ['Siglo VI a. C.', 'Pitágoras y su escuela en Crotona: "todo es número"'],
      ['Siglo III a. C.', 'Isopsefia griega: sumar el valor de las letras de una palabra'],
      ['78 a. C.', 'Gematría hebrea en Talmud y Midrash'],
      ['Siglo I', 'El 666 del Apocalipsis'],
      ['Siglos VIII–IX', 'Numerales abjad árabes; la alquimia de Jábir ibn Hayyán'],
      ['Siglos XII–XIII', 'La Cábala medieval revive la gematría (Abulafia)'],
      ['1531', 'Agrippa, De occulta philosophia: fija significados que la numerología hereda'],
      ['1908', 'Mrs. L. Dow Balliett publica el sistema moderno: tabla pitagórica y maestros 11 y 22'],
      ['c. 1907–1910', 'La Dra. Julia Seton acuña la palabra "numerología"'],
      ['1926', 'Cheiro, Book of Numbers: populariza el sistema caldeo'],
      ['1965', 'Juno Jordan formaliza pináculos, desafíos y ciclos: el canon actual'],
      ['1994', 'Hans Decoz: progresiones año por año, base del software'],
      ['1997', 'Underwood Dudley: la gran crítica desde las matemáticas'],
      ['2010–hoy', 'Apps, redes sociales y "números ángel" (111, 222)'],
    ]),
    Subtitulo('Tres lecciones de la historia'),
    Vinetas([
      'Todo alfabeto que se usó para contar generó su numerología: griegos, hebreos y árabes escribían los números con letras.',
      'El alfabeto latino no tiene valores propios: la tabla A=1, B=2… es una convención moderna y arbitraria.',
      'La numerología moderna es una síntesis del siglo XX: filosofía pitagórica + ocultismo renacentista + Nuevo Pensamiento.',
    ]),
  ]),
  Modulo(3, 'Los sistemas', 'Cinco escuelas que dan resultados distintos para el mismo nombre.', [
    Parrafo('El sistema pitagórico es el estándar occidental y el que usa esta app para la carta.'),
    Tabla([
      'Sistema',
      'Qué convierte',
      'Rasgo distintivo'
    ], [
      ['Pitagórico', 'Nombre de nacimiento + fecha', 'A=1…I=9, J=1…; reduce a 1–9 salvo 11, 22, 33'],
      ['Caldeo', 'Nombre de uso diario', 'Valores por "sonido" del 1 al 8; el 9 no se asigna; lee compuestos'],
      ['Cabalístico', 'Solo el nombre', '22 valores ligados a las letras hebreas'],
      ['Chino', 'Números cotidianos', '8 suena a "prosperidad", 4 a "muerte"; cuadrado Lo Shu'],
      ['Védico', 'Día y fecha; nombre con tabla caldea', 'Cada número se rige por un planeta'],
    ]),
    Subtitulo('Tabla pitagórica'),
    Tabla([
      '1', '2', '3', '4', '5', '6', '7', '8', '9'
    ], [
      ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'],
      ['J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R'],
      ['S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ''],
    ]),
    Parrafo('En español, la Ñ suele valer 5 (como la N) o 6 según el autor; los acentos se ignoran. '
        'Puedes elegir el valor en Ajustes.'),
    Subtitulo('Tabla caldea'),
    Tabla([
      '1', '2', '3', '4', '5', '6', '7', '8'
    ], [
      ['A I J Q Y', 'B K R', 'C G L S', 'D M T', 'E H N X', 'U V W', 'O Z', 'F P'],
    ]),
    Destacado(
        'La F vale 6 en el pitagórico y 8 en el caldeo; la O vale 6 y 7. Si dos sistemas dan '
        '"vibraciones" distintas a la misma letra, ¿cuál describe a la persona?',
        critico: true),
  ]),
  Modulo(4, 'Cómo se calcula', 'Todo descansa en la reducción teosófica: sumar dígitos hasta llegar a uno.', [
    Parrafo('Ejemplo: 1990 → 1+9+9+0 = 19 → 1+9 = 10 → 1+0 = 1.'),
    Subtitulo('Las tres reglas'),
    Vinetas([
      'Reducir por partes. En fechas se reduce primero mes, día y año por separado, y luego se suman. En nombres, cada palabra por separado.',
      'Respetar los números maestros. Si una suma da 11, 22 o 33, no se reduce: 11/2, 22/4, 33/6.',
      'Anotar los números de deuda kármica. Si antes de la reducción final aparece 13, 14, 16 o 19, se anota (13/4, 14/5, 16/7, 19/1).',
    ], numeradas: true),
    Subtitulo('Ejemplo resuelto: Ana María López Ruiz, 14/07/1990'),
    Vinetas([
      'Camino de Vida: mes 7 + día 14 → 5 + año 1990 → 1 = 13 → 4 (deuda kármica 13/4).',
      'Expresión: ANA 7 + MARÍA 6 + LÓPEZ 11 + RUIZ 11 → 8 (suma directa de letras: 89).',
      'Impulso del Alma (vocales): 36 → 9.',
      'Personalidad (consonantes): 53 → 8.',
      'Comprobación: Alma + Personalidad = Expresión (36 + 53 = 89).',
      'Cumpleaños: 14 → 5 (también deuda kármica). Madurez: 4 + 8 = 12 → 3.',
      'Año Personal 2026: 7 + 5 + 1 = 13 → 4.',
    ]),
    Parrafo('Puedes abrir este ejemplo en la pestaña Cartas para ver cada paso.'),
    Subtitulo('Puntos de discusión entre escuelas'),
    Vinetas([
      'La Y: algunos la cuentan como vocal cuando suena a "i" (configurable en Ajustes).',
      'El nombre: casi todos usan el de nacimiento; otros, el de uso diario o el de casada.',
      'La fecha: unos suman todos los dígitos juntos, otros por partes; los maestros intermedios pueden cambiar.',
    ]),
    Destacado('Estas variantes significan que dos numerólogos pueden darle a la misma persona cartas distintas.',
        critico: true),
  ]),
  Modulo(5, 'Los números núcleo y los ciclos',
      'Seis números núcleo y varios ciclos de tiempo. El Camino de Vida es el más importante.', [
    Tabla([
      'Número',
      'Se calcula con',
      'Qué dice representar'
    ], [
      ['Camino de Vida', 'Fecha completa', 'El rumbo y las lecciones de la vida'],
      ['Expresión (Destino)', 'Todas las letras', 'Talentos y forma de actuar'],
      ['Impulso del Alma', 'Vocales', 'Lo que la persona desea por dentro'],
      ['Personalidad', 'Consonantes', 'Cómo la perciben los demás'],
      ['Cumpleaños', 'Día de nacimiento', 'Un talento específico'],
      ['Madurez', 'Camino de Vida + Expresión', 'La meta de la segunda mitad de la vida'],
    ]),
    Subtitulo('Los ciclos de tiempo'),
    Vinetas([
      'Año Personal: mes + día de nacimiento + año en curso. Ciclo de 9 años: el 1 inicia, el 5 trae cambio, el 9 cierra.',
      'Mes Personal = Año Personal + mes en curso. Día Personal = Mes Personal + día en curso.',
      'Año Universal: solo el año en curso (2026 → 1, un año "de inicios").',
      'Pináculos: 1.º M + D (hasta los 36 − Camino de Vida), 2.º D + A (9 años), 3.º 1.º + 2.º (9 años), 4.º M + A.',
      'Desafíos: se restan. 1.º |M − D|, 2.º |D − A|, principal |1.º − 2.º|, 4.º |M − A|. Es el único lugar donde aparece el 0.',
    ]),
    Subtitulo('Extras de la carta'),
    Vinetas([
      'Tabla de inclusión: cuántas veces aparece cada número en el nombre. Un número ausente es una "lección kármica".',
      'Planos de expresión: reparten las letras en físico, mental, emocional e intuitivo.',
      'Números puente: la diferencia entre dos números núcleo.',
    ]),
  ]),
  Modulo(6, 'El significado de cada número',
      'Cada número es un arquetipo con una cara luminosa y una sombra.', [
    Parrafo('Los significados vienen de la tradición Balliett-Jordan y son los que repiten casi todos los '
        'libros y apps. Son convenciones del sistema, no hallazgos. Los encontrarás completos en la '
        'pestaña Números.'),
    Subtitulo('Cómo leer una carta (método del numerólogo)'),
    Vinetas([
      'Empezar por el Camino de Vida: es el "tema" de la persona.',
      'Comparar Alma (lo que quiere) con Personalidad (lo que muestra).',
      'Buscar repeticiones: un número que aparece tres veces se lee como dominante.',
      'Situar el momento con el Año Personal y el Pináculo activo.',
      'Formular la lectura como preguntas, no como sentencias.',
    ], numeradas: true),
    Destacado(
        'Casi todos los arquetipos describen rasgos que cualquier persona reconoce en sí misma en algún '
        'momento. Ese es el efecto Barnum que analiza el Módulo 7.',
        critico: true),
  ]),
  Modulo(7, 'Qué dice la ciencia',
      'Cada vez que se ha puesto a prueba con datos, sus resultados no se distinguen del azar.', [
    Tabla([
      'Año',
      'Estudio',
      'Resultado'
    ], [
      ['2017', 'Genovese: ¿el número de nacimiento predice a los Nobel 1901–2010?', 'No difiere del azar (χ² = 4,92; p = 0,77)'],
      ['2012', 'Diamant y Sternberg: ¿detecta autismo o problemas de aprendizaje en 81 personas?', 'No mejor que adivinar'],
      ['1993', 'Townsend (ASSAP): ¿los nombres en 7 son más "psíquicos"?', 'El 7 quedó séptimo de nueve'],
      ['1949', 'Forer: 39 estudiantes calificaron un perfil que era el mismo para todos', '4,26 sobre 5 de precisión: efecto Barnum'],
    ]),
    Subtitulo('Por qué no es ciencia'),
    Vinetas([
      'Sin mecanismo: no hay explicación física de cómo una suma de letras influye en alguien.',
      'Arbitrariedad: la tabla A=1, B=2 es una convención; el caldeo da otro resultado.',
      'Infalsable: cada número tiene luz y sombra, así que cualquier conducta encaja.',
      'Inconsistencia: las escuelas no se ponen de acuerdo en cómo calcular.',
    ]),
    Subtitulo('Por qué se siente cierta'),
    Vinetas([
      'Efecto Barnum/Forer: frases vagas y halagadoras se viven como personales.',
      'Sesgo de confirmación: recordamos los aciertos y olvidamos los fallos.',
      'Apofenia: el cerebro busca patrones, y los números tienen patrones reales que parecen místicos.',
      'Necesidad de control y sentido: un marco que "explica" la vida reduce la ansiedad.',
      'Profecía autocumplida: quien cree que es un "8 ejecutivo" puede comportarse más como tal.',
    ]),
    Destacado(
        'La ciencia no dice que la numerología sea inútil para todo; dice que no predice ni describe mejor '
        'que el azar. Su valor, si lo tiene, está en lo que provoca: conversación, reflexión y narrativa personal.'),
  ]),
  Modulo(8, 'Qué podemos hacer con ella', 'Úsala para hacer preguntas, nunca para dar respuestas definitivas.', [
    Subtitulo('Usos legítimos'),
    Vinetas([
      'Autorreflexión y diario personal.',
      'Coaching y talleres: los arquetipos como tarjetas de conversación.',
      'Escritura y diseño de personajes.',
      'Estudio cultural e histórico.',
      'Branding y naming: las creencias del cliente sí mueven compras.',
      'Contenido y entretenimiento.',
      'Pedagogía del pensamiento crítico: repetir el experimento de Forer.',
    ]),
    Subtitulo('Usos a evitar'),
    Vinetas([
      'Elegir pareja, socio, empleado o nombre de un hijo descartando personas por su número.',
      'Decidir inversiones, fechas de cirugía o tratamientos médicos.',
      'Vender lecturas como diagnóstico psicológico o promesa de resultados.',
    ]),
    Subtitulo('Ética para quien la ofrezca'),
    Vinetas([
      'Presentarla como herramienta simbólica, no como ciencia.',
      'No crear dependencia.',
      'Derivar a un profesional ante temas de salud mental, duelo o crisis.',
      'No usar miedos para vender servicios.',
    ]),
  ]),
  Modulo(9, 'Biblioteca', 'Tres miradas: la del practicante, la académica y la crítica.', [
    Subtitulo('Libros del practicante'),
    Tabla([
      'Libro',
      'Autor',
      'Año'
    ], [
      ['The Philosophy of Numbers', 'L. Dow Balliett', '1908'],
      ["Cheiro's Book of Numbers", 'Cheiro', '1926'],
      ['Numerology: The Romance in Your Name', 'Juno Jordan', '1965'],
      ['Numerology: Key to Your Inner Self', 'Hans Decoz y Tom Monte', '1994'],
      ['Numerology with Tantra, Ayurveda, and Astrology', 'Harish Johari', '1990'],
      ['Glynis Has Your Number', 'Glynis McCants', '2005'],
      ['El pequeño libro de la numerología', 'Kelli Miller', '2025'],
      ['Numerología mágica', 'Gladys Lobos', '2008'],
    ]),
    Subtitulo('Libros académicos y críticos'),
    Tabla([
      'Libro',
      'Autor',
      'Año'
    ], [
      ['Numerology: Or What Pythagoras Wrought', 'Underwood Dudley', '1997'],
      ['The Mystery of Numbers', 'Annemarie Schimmel', '1993'],
      ['Medieval Number Symbolism', 'Vincent F. Hopper', '1938'],
      ['El mundo y sus demonios', 'Carl Sagan', '1995'],
      ['Por qué creemos en cosas raras', 'Michael Shermer', '1997'],
    ]),
    Subtitulo('Podcasts'),
    Vinetas([
      'Skeptoid #626 · Numerology (inglés, crítica)',
      'The Numerology Podcast (inglés, practicante)',
      'Numerology: GPS for the Soul (inglés, practicante)',
      'Felicia Bender (inglés, practicante)',
      'Cambia tu vida con la numerología (español, practicante)',
      'De paso por la vida (español, practicante)',
      'Numerología Conductual (español, practicante)',
    ]),
  ]),
  Modulo(10, 'Ejercicios y glosario', 'Calcula tu carta, ponla a prueba y repasa los términos.', [
    Subtitulo('Ejercicios prácticos'),
    Vinetas([
      'Tu carta: calcula tus seis números núcleo y comprueba que Alma + Personalidad = Expresión.',
      'Dos sistemas: compara tu número pitagórico con el caldeo (pestaña Nombre de tu carta).',
      'Tu año: mira tu Año Personal 2026 y 2027 y tu Pináculo activo (pestaña Ciclos).',
      'Prueba a ciegas: entrega a 5 personas tres descripciones de Camino de Vida sin decir cuál es la suya. El azar da 1 de cada 3.',
      'Experimento de Forer: da a un grupo el mismo texto como "lectura personal" y compara su nota con el 4,26 de 1949.',
      'Uso con propósito: diseña una sesión de 30 minutos de reflexión con las reglas éticas del Módulo 8.',
    ], numeradas: true),
    Subtitulo('Glosario'),
    Tabla([
      'Término',
      'Definición'
    ], [
      ['Aritmancia', 'Nombre antiguo de la numerología'],
      ['Gematría', 'Sistema hebreo que da valor numérico a las letras'],
      ['Isopsefia', 'Equivalente griego de la gematría'],
      ['Abjad', 'Sistema árabe de valores numéricos de las letras'],
      ['Reducción teosófica', 'Sumar dígitos hasta obtener uno solo'],
      ['Número maestro', '11, 22 o 33; no se reduce'],
      ['Deuda kármica', '13, 14, 16 o 19 antes de la reducción final'],
      ['Camino de Vida', 'Número de la fecha de nacimiento completa'],
      ['Expresión / Destino', 'Número de todas las letras del nombre'],
      ['Impulso del Alma', 'Número de las vocales'],
      ['Personalidad', 'Número de las consonantes'],
      ['Pináculo', 'Cada una de las cuatro grandes etapas de la vida'],
      ['Desafío', 'Obstáculo de cada pináculo; se calcula restando'],
      ['Año Personal', 'Ciclo anual del 1 al 9'],
      ['Números ángel', 'Secuencias repetidas (111, 222) a las que se atribuye un mensaje'],
      ['Efecto Barnum / Forer', 'Aceptar descripciones vagas como si fueran personales'],
      ['Sesgo de confirmación', 'Recordar lo que confirma una creencia y olvidar lo que la contradice'],
      ['Pseudociencia', 'Práctica que se presenta como científica sin seguir el método científico'],
    ]),
  ]),
];

/// Evaluación final en formato de opción múltiple.
class Pregunta {
  const Pregunta(this.enunciado, this.opciones, this.correcta, this.explicacion);
  final String enunciado;
  final List<String> opciones;
  final int correcta;
  final String explicacion;
}

const evaluacion = <Pregunta>[
  Pregunta('¿Quién publicó el sistema moderno de numerología y en qué año?', [
    'Pitágoras, siglo VI a. C.',
    'Mrs. L. Dow Balliett, 1908',
    'Cheiro, 1926',
    'Hans Decoz, 1994',
  ], 1, 'Balliett publicó en 1908 la tabla pitagórica, los números de nombre y de nacimiento y los maestros 11 y 22.'),
  Pregunta('¿Por qué el sistema "pitagórico" no es obra de Pitágoras?', [
    'Porque Pitágoras usaba la tabla caldea',
    'Porque el alfabeto latino no tiene valores propios y la tabla A=1, B=2 es una convención moderna',
    'Porque Pitágoras nunca estudió los números',
    'Porque fue inventado en China',
  ], 1, 'La filosofía "todo es número" es pitagórica; la tabla y el método son del siglo XX.'),
  Pregunta('¿Qué Camino de Vida resulta para el 29/11/1987?', ['7', '2', '11/2', '29'], 2,
      'Mes 11 (maestro), día 29 → 11 (maestro), año 1987 → 25 → 7. Total 11 + 11 + 7 = 29 → 11.'),
  Pregunta('¿Qué números no se reducen?', ['13, 14, 16 y 19', '11, 22 y 33', '1, 5 y 9', 'Ninguno'], 1,
      'Los números maestros 11, 22 y 33 se conservan y se escriben 11/2, 22/4, 33/6.'),
  Pregunta('¿Qué son los números 13, 14, 16 y 19?', [
    'Números maestros',
    'Números de deuda kármica',
    'Números ángel',
    'Años universales',
  ], 1, 'Si aparecen antes de la reducción final se anotan como "lecciones pendientes".'),
  Pregunta('¿Qué diferencia hay entre la tabla pitagórica y la caldea?', [
    'Son iguales',
    'La pitagórica va en orden A=1…I=9; la caldea asigna por "sonido" del 1 al 8 y no usa el 9',
    'La caldea solo usa vocales',
    'La pitagórica es babilónica',
  ], 1, 'Por eso un mismo nombre da números distintos según el sistema.'),
  Pregunta('¿Qué encontró el estudio de Genovese (2017) sobre los ganadores del Nobel?', [
    'Que la mayoría tiene Camino de Vida 1',
    'Que la distribución de sus números no difiere del azar',
    'Que los 7 ganan más premios de física',
    'Que el estudio no se pudo completar',
  ], 1, 'χ² = 4,92; p = 0,77: ningún número aparece más de lo esperable por azar.'),
  Pregunta('¿Qué es el efecto Barnum o Forer?', [
    'Recordar solo los aciertos',
    'Aceptar descripciones vagas y halagadoras como si fueran personales',
    'Ver patrones donde no los hay',
    'Comportarse como dice una predicción',
  ], 1, 'En 1949, 39 estudiantes puntuaron 4,26 sobre 5 un perfil que era el mismo para todos.'),
  Pregunta('¿Cuál de estos es un uso legítimo de la numerología?', [
    'Elegir a un empleado por su número',
    'Decidir la fecha de una cirugía',
    'Usar los arquetipos como tarjetas de conversación en un taller',
    'Venderla como diagnóstico psicológico',
  ], 2, 'Sirve bien para reflexión, narrativa y entretenimiento; mal para decisiones de salud, dinero o contratación.'),
  Pregunta('¿Por qué se dice que la numerología es infalsable?', [
    'Porque sus cálculos son exactos',
    'Porque cada número tiene luz y sombra, así que cualquier conducta encaja',
    'Porque es muy antigua',
    'Porque la usan millones de personas',
  ], 1, 'Una teoría que no puede fallar no explica nada.'),
];
