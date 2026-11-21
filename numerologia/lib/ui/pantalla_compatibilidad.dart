import 'package:material_ui/material_ui.dart';

import '../core/carta.dart';
import '../core/compatibilidad.dart';
import '../core/reduccion.dart';
import '../data/significados.dart';
import '../state/app_state.dart';
import 'widgets.dart';

/// Compara las cartas de dos personas guardadas.
class PantallaCompatibilidad extends StatefulWidget {
  const PantallaCompatibilidad({super.key, this.idA, this.idB});

  final String? idA;
  final String? idB;

  @override
  State<PantallaCompatibilidad> createState() => _PantallaCompatibilidadState();
}

class _PantallaCompatibilidadState extends State<PantallaCompatibilidad> {
  String? _idA;
  String? _idB;

  @override
  void initState() {
    super.initState();
    _idA = widget.idA;
    _idB = widget.idB;
  }

  Future<void> _elegir(bool primera) async {
    final state = AppScope.of(context);
    final otro = primera ? _idB : _idA;
    final elegido = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(primera ? 'Primera persona' : 'Segunda persona', style: Theme.of(c).textTheme.titleMedium),
            ),
            for (final p in state.personas)
              if (p.id != otro)
                ListTile(
                  leading: NumeroCirculo(state.cartaDe(p).caminoVida.etiqueta, tamano: 40),
                  title: Text(p.nombre),
                  onTap: () => Navigator.pop(c, p.id),
                ),
          ],
        ),
      ),
    );
    if (elegido != null) setState(() => primera ? _idA = elegido : _idB = elegido);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final a = _idA == null ? null : state.buscar(_idA!);
    final b = _idB == null ? null : state.buscar(_idB!);
    final comp = (a != null && b != null) ? Compatibilidad(state.cartaDe(a), state.cartaDe(b)) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Compatibilidad')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Expanded(child: _Selector(persona: a, carta: a == null ? null : state.cartaDe(a), onTap: () => _elegir(true))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.sync_alt)),
                  Expanded(child: _Selector(persona: b, carta: b == null ? null : state.cartaDe(b), onTap: () => _elegir(false))),
                ]),
                const SizedBox(height: 12),
                if (state.personas.length < 2)
                  const AvisoSimbolico(texto: 'Necesitas al menos dos cartas guardadas. Crea otra en la pestaña Cartas.')
                else if (comp == null)
                  const AvisoSimbolico(texto: 'Elige dos personas para comparar sus cartas.')
                else
                  ..._resultado(context, comp),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _resultado(BuildContext context, Compatibilidad c) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final rel = c.numeroRelacion;
    final relArq = arquetipoDe(rel.valor)!;
    final hoy = DateTime.now().year;
    final (apA, apB) = c.anosPersonales(hoy);

    final preguntas = <String>{
      'Como pareja o equipo: ${relArq.pregunta}',
      for (final x in c.cruces)
        if (x.alma.base != x.personalidad.base)
          '${x.quienDesea} busca "${arquetipoDe(x.alma.valor)!.palabraClave.toLowerCase()}" y ${x.quienMuestra} muestra '
              '"${arquetipoDe(x.personalidad.valor)!.palabraClave.toLowerCase()}". ¿Cómo se encuentran esas dos cosas?',
      for (final comp in c.comparaciones)
        if (comp.tipo == TipoAfinidad.espejo)
          'Comparten ${comp.nombre} ${comp.a.base}: ¿cómo evitan caer juntos en "${arquetipoDe(comp.a.base)!.sombra.toLowerCase()}"?',
    };

    return [
      const AvisoSimbolico(
        texto: 'Una comparación para conversar, no un veredicto. El curso desaconseja elegir pareja, socio o '
            'empleado descartando personas por su número, así que aquí no hay puntuaciones ni "incompatibles".',
      ),
      const SizedBox(height: 12),
      Seccion(
        titulo: 'Número de la relación',
        icono: Icons.all_inclusive,
        subtitulo: 'Suma de los dos Caminos de Vida: el tema que comparten.',
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => mostrarSignificado(context,
              titulo: 'Número de la relación',
              numero: rel.valor,
              reduccion: rel,
              calculo: '${c.a.caminoVida.valor} + ${c.b.caminoVida.valor} = ${rel.bruto}'),
          child: Row(children: [
            NumeroCirculo(rel.etiqueta, tamano: 64, maestro: rel.esMaestro),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(relArq.nombre, style: tt.titleMedium),
                Text('${c.a.caminoVida.valor} + ${c.b.caminoVida.valor} = ${rel.pasos}', style: tt.bodySmall),
                const SizedBox(height: 4),
                Text('Luz: ${relArq.luz.toLowerCase()}. Sombra: ${relArq.sombra.toLowerCase()}.', style: tt.bodyMedium),
              ]),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      Seccion(
        titulo: 'Números núcleo, lado a lado',
        icono: Icons.compare_arrows,
        subtitulo: 'Espejo: ${c.cuantos(TipoAfinidad.espejo)} · Afinidad natural: ${c.cuantos(TipoAfinidad.natural)} · '
            'Complementarios: ${c.cuantos(TipoAfinidad.complementaria)}',
        child: Column(children: [
          for (final comp in c.comparaciones) _FilaComparacion(comp: comp, nombreA: c.nombreA, nombreB: c.nombreB),
        ]),
      ),
      const SizedBox(height: 12),
      Seccion(
        titulo: 'Lo que uno desea y lo que el otro muestra',
        icono: Icons.favorite_outline,
        subtitulo: 'Impulso del Alma de cada uno frente a la Personalidad del otro.',
        child: Column(children: [
          for (final x in c.cruces)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Row(mainAxisSize: MainAxisSize.min, children: [
                NumeroCirculo(x.alma.etiqueta, tamano: 36, maestro: x.alma.esMaestro),
                const Icon(Icons.arrow_right_alt, size: 18),
                NumeroCirculo(x.personalidad.etiqueta, tamano: 36, maestro: x.personalidad.esMaestro),
              ]),
              title: Text('Alma de ${x.quienDesea} · Personalidad de ${x.quienMuestra}'),
              subtitle: Text(x.puente == 0
                  ? 'Lo que ${x.quienDesea} busca es justo lo que ${x.quienMuestra} muestra.'
                  : 'Puente ${x.puente}: ${arquetipoDe(x.puente)!.palabraClave.toLowerCase()}.'),
            ),
        ]),
      ),
      const SizedBox(height: 12),
      Seccion(
        titulo: 'Su momento en $hoy',
        icono: Icons.calendar_month_outlined,
        subtitulo: 'Años personales: si coinciden, recorren el ciclo de 9 años al mismo ritmo.',
        child: Row(children: [
          _AnoPersonal(nombre: c.nombreA, r: apA),
          Expanded(
            child: Text(
              apA.valor == apB.valor
                  ? 'Mismo año personal'
                  : '${(apA.valor - apB.valor).abs()} ${(apA.valor - apB.valor).abs() == 1 ? 'año' : 'años'} de desfase',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          _AnoPersonal(nombre: c.nombreB, r: apB),
        ]),
      ),
      const SizedBox(height: 12),
      Seccion(
        titulo: 'Preguntas para conversar',
        icono: Icons.forum_outlined,
        child: Column(children: [
          for (final p in preguntas)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.help_outline),
              title: Text(p, style: tt.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
            ),
        ]),
      ),
      const SizedBox(height: 12),
      const AvisoSimbolico(
        texto: 'Las familias de números (1-5-7, 2-4-8, 3-6-9) son una convención de los libros de práctica, '
            'no del curso ni de la ciencia. Dos personas con números "distintos" pueden llevarse de maravilla.',
      ),
    ];
  }
}

class _Selector extends StatelessWidget {
  const _Selector({required this.persona, required this.carta, required this.onTap});

  final Persona? persona;
  final Carta? carta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            NumeroCirculo(carta?.caminoVida.etiqueta ?? '?', tamano: 52, maestro: carta?.caminoVida.esMaestro ?? false),
            const SizedBox(height: 8),
            Text(persona?.nombre ?? 'Elegir persona',
                style: tt.labelLarge, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text('Cambiar', style: tt.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
          ]),
        ),
      ),
    );
  }
}

class _FilaComparacion extends StatelessWidget {
  const _FilaComparacion({required this.comp, required this.nombreA, required this.nombreB});

  final ComparacionNumero comp;
  final String nombreA;
  final String nombreB;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final color = switch (comp.tipo) {
      TipoAfinidad.espejo => cs.tertiaryContainer,
      TipoAfinidad.natural => cs.primaryContainer,
      TipoAfinidad.complementaria => cs.secondaryContainer,
    };
    final familias = comp.familiaA == comp.familiaB
        ? '${comp.familiaA.nombre}: ${comp.familiaA.valora}'
        : '$nombreA, ${comp.familiaA.nombre.toLowerCase()} (${comp.familiaA.valora}); '
            '$nombreB, ${comp.familiaB.nombre.toLowerCase()} (${comp.familiaB.valora})';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _detalle(context),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(comp.nombre, style: tt.titleSmall)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                child: Text(comp.tipo.nombre, style: tt.labelSmall),
              ),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              NumeroCirculo(comp.a.etiqueta, tamano: 40, maestro: comp.a.esMaestro),
              Expanded(
                child: Column(children: [
                  Text(comp.puente == 0 ? 'Mismo número' : 'Puente ${comp.puente}', style: tt.labelMedium),
                  if (comp.puente > 0)
                    Text(arquetipoDe(comp.puente)!.palabraClave,
                        style: tt.labelSmall?.copyWith(color: cs.tertiary)),
                ]),
              ),
              NumeroCirculo(comp.b.etiqueta, tamano: 40, maestro: comp.b.esMaestro),
            ]),
            const SizedBox(height: 4),
            Text(familias, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ]),
        ),
      ),
    );
  }

  void _detalle(BuildContext context) {
    final puente = comp.puente;
    if (puente == 0) {
      mostrarSignificado(context,
          titulo: '${comp.nombre} compartido', numero: comp.a.valor, reduccion: comp.a, definicionClave: comp.nombre);
    } else {
      mostrarSignificado(context,
          titulo: 'Puente de ${comp.nombre}',
          numero: puente,
          reduccion: reducir(puente),
          calculo: '|${comp.a.base} − ${comp.b.base}| = $puente  ·  ${comp.tipo.descripcion}');
    }
  }
}

class _AnoPersonal extends StatelessWidget {
  const _AnoPersonal({required this.nombre, required this.r});

  final String nombre;
  final Reduccion r;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(children: [
      NumeroCirculo('${r.valor}', tamano: 48),
      const SizedBox(height: 4),
      Text(nombre, style: tt.labelMedium),
      Text(arquetipoDe(r.valor)!.palabraClave, style: tt.labelSmall?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
    ]);
  }
}
