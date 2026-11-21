# Numerología

App Flutter de numerología basada en el documento *Curso de Numerología: qué es, cómo funciona y qué dice la evidencia*.

## Qué hace

- **Cartas**: calcula y guarda la carta pitagórica de cada persona (nombre completo de nacimiento + fecha).
  - **Núcleo**: Camino de Vida, Expresión, Impulso del Alma, Personalidad, Cumpleaños y Madurez, con números maestros (11/2, 22/4, 33/6), deudas kármicas (13/4, 14/5, 16/7, 19/1) y la comprobación Alma + Personalidad = Expresión.
  - **Ciclos**: Año, Mes y Día Personal, Año Universal (con selector de año), pináculos con edades y etapa actual, y desafíos.
  - **Nombre**: desglose letra por letra, tabla de inclusión, lecciones kármicas, planos de expresión, números puente y comparación con el sistema caldeo.
  - **Lectura**: lectura guiada con el método del curso, formulada como preguntas.
- **Compatibilidad**: compara dos cartas guardadas. Muestra el número de la relación (suma de los Caminos de Vida), los números núcleo lado a lado con su número puente y su familia (1-5-7, 2-4-8, 3-6-9), el Alma de cada uno frente a la Personalidad del otro, los años personales de ambos y preguntas para conversar. No da puntuaciones ni etiquetas de "incompatible", siguiendo el Módulo 8 del curso.
- **Números**: arquetipos del 1 al 9 y maestros (luz, sombra, palabra clave), más las deudas kármicas.
- **Aprender**: los 10 módulos del curso y la evaluación final de 10 preguntas.
- **Ajustes**: valor de la Ñ (5 o 6) y tratamiento de la Y (consonante, vocal o según el sonido).

La app presenta la numerología como lo hace el curso: un sistema simbólico para reflexionar, no una ciencia.

## Reglas de cálculo

- Las fechas se reducen por partes (mes, día y año) y después se suman. Los nombres se reducen palabra por palabra.
- 11, 22 y 33 no se reducen. 13, 14, 16 y 19 se anotan si aparecen antes de la reducción final.
- Los acentos se ignoran.
- Pináculos: el 1.º termina a los 36 − Camino de Vida. Desafíos: |M − D|, |D − A|, |1.º − 2.º|, |M − A|.
- Año, Mes y Día Personal se reducen a 1–9.

`test/calculo_test.dart` verifica el ejemplo resuelto del curso (Ana María López Ruiz, 14/07/1990) y la clave de la evaluación (29/11/1987 → 11/2).

## Ejecutar

```bash
flutter pub get
flutter test
flutter run            # Android / iOS / Chrome
flutter build web      # versión web en build/web
```

Requiere Flutter 3.50 o superior (usa el paquete `material_ui`).
