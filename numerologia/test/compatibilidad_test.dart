import 'package:flutter_test/flutter_test.dart';
import 'package:numerologia/core/carta.dart';
import 'package:numerologia/core/compatibilidad.dart';
import 'package:numerologia/core/letras.dart';

void main() {
  final ana = Carta.calcular(
    Persona(id: 'a', nombre: 'Ana María López Ruiz', nacimiento: DateTime(1990, 7, 14)),
    const Ajustes(),
  );
  final otra = Carta.calcular(
    Persona(id: 'b', nombre: 'Prueba', nacimiento: DateTime(1987, 11, 29)),
    const Ajustes(),
  );
  final comp = Compatibilidad(ana, otra);

  test('familias de números', () {
    expect(Familia.de(1), Familia.mental);
    expect(Familia.de(8), Familia.practica);
    expect(Familia.de(9), Familia.creativa);
  });

  test('número de la relación: 4 + 11 = 15 → 6', () {
    expect(comp.numeroRelacion.cadena, [15, 6]);
  });

  test('Camino de Vida 4 frente a 11/2: misma familia práctica, puente 2', () {
    final cv = comp.comparaciones.first;
    expect(cv.tipo, TipoAfinidad.natural);
    expect(cv.puente, 2);
  });

  test('consigo misma todo es espejo', () {
    final yo = Compatibilidad(ana, ana);
    expect(yo.cuantos(TipoAfinidad.espejo), 4);
    expect(yo.comparaciones.every((c) => c.puente == 0), isTrue);
  });

  test('cruce Alma de Ana (9) frente a Personalidad de la otra persona', () {
    expect(comp.cruces.first.alma.valor, 9);
    expect(comp.nombreA, 'Ana');
  });
}
