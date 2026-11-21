import 'package:flutter_test/flutter_test.dart';
import 'package:numerologia/core/carta.dart';
import 'package:numerologia/core/letras.dart';
import 'package:numerologia/core/reduccion.dart';

void main() {
  group('Reducción teosófica', () {
    test('1990 → 19 → 10 → 1', () => expect(reducir(1990).cadena, [1990, 19, 10, 1]));
    test('respeta maestros', () {
      expect(reducir(29).etiqueta, '11/2');
      expect(reducir(22).valor, 22);
      expect(reducir(33).etiqueta, '33/6');
    });
    test('anota deuda kármica', () {
      expect(reducir(13).etiqueta, '13/4');
      expect(reducir(14).etiqueta, '14/5');
      expect(reducir(16).etiqueta, '16/7');
      expect(reducir(19).etiqueta, '19/1');
      expect(reducir(49).etiqueta, '13/4');
    });
  });

  group('Ejemplo del curso: Ana María López Ruiz, 14/07/1990', () {
    final carta = Carta.calcular(
      Persona(id: 'x', nombre: 'Ana María López Ruiz', nacimiento: DateTime(1990, 7, 14)),
      const Ajustes(),
    );

    test('Camino de Vida 13/4', () => expect(carta.caminoVida.etiqueta, '13/4'));
    test('Expresión 8 con palabras 7, 6, 11, 11', () {
      expect(carta.expresion.reduccion.valor, 8);
      expect(carta.expresion.palabras.map((p) => p.suma), [7, 24, 29, 29]);
      expect(carta.expresion.palabras.map((p) => p.reduccion.valor), [7, 6, 11, 11]);
      expect(carta.expresion.sumaDirecta, 89);
    });
    test('Alma 9 (36) y Personalidad 8 (53)', () {
      expect(carta.alma.reduccion.valor, 9);
      expect(carta.alma.sumaDirecta, 36);
      expect(carta.personalidad.reduccion.valor, 8);
      expect(carta.personalidad.sumaDirecta, 53);
      expect(carta.alma.sumaDirecta + carta.personalidad.sumaDirecta, carta.expresion.sumaDirecta);
    });
    test('Cumpleaños 14/5 y Madurez 3', () {
      expect(carta.cumpleanos.etiqueta, '14/5');
      expect(carta.madurez.valor, 3);
    });
    test('Año Personal 2026 = 4, Año Universal 1', () {
      expect(carta.anoPersonal(2026).valor, 4);
      expect(Carta.anoUniversal(2026).valor, 1);
    });
    test('Pináculos 3, 6, 9, 8 con edades', () {
      final p = carta.pinaculos;
      expect(p.map((e) => e.numero.valor), [3, 6, 9, 8]);
      expect(p.map((e) => e.edades), ['0–32', '33–41', '42–50', '51 en adelante']);
    });
    test('Desafíos 2, 4, 2, 6', () => expect(carta.desafios.map((d) => d.valor), [2, 4, 2, 6]));
    test('Puente Alma − Personalidad = 1', () => expect(carta.puentes.first.valor, 1));
  });

  test('Clave de la evaluación: 29/11/1987 → Camino de Vida 11/2', () {
    final carta = Carta.calcular(
      Persona(id: 'y', nombre: 'Prueba', nacimiento: DateTime(1987, 11, 29)),
      const Ajustes(),
    );
    expect(carta.mes.valor, 11);
    expect(carta.dia.valor, 11);
    expect(carta.ano.valor, 7);
    expect(carta.caminoVida.etiqueta, '11/2');
  });

  group('Letras', () {
    test('acentos ignorados y Ñ configurable', () {
      expect(analizarNombre('Peña', const Ajustes()).first.letras[2].valor, 5);
      expect(analizarNombre('Peña', const Ajustes(valorEnie: 6)).first.letras[2].valor, 6);
      expect(analizarNombre('José', const Ajustes()).first.texto, 'JOSE');
    });
    test('Y según sonido', () {
      const a = Ajustes(modoY: ModoY.segunSonido);
      expect(analizarNombre('Lyn', a).first.letras[1].vocal, isTrue);
      expect(analizarNombre('Yolanda', a).first.letras[0].vocal, isFalse);
    });
  });
}
