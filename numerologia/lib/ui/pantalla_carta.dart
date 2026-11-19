import 'package:material_ui/material_ui.dart';

import '../core/carta.dart';
import '../core/reduccion.dart';
import '../data/curso.dart';
import '../data/significados.dart';
import '../state/app_state.dart';
import 'formulario_persona.dart';
import 'pantalla_cartas.dart' show formatoFecha;
import 'widgets.dart';

class PantallaCarta extends StatelessWidget {
  const PantallaCarta({super.key, required this.personaId});

  final String personaId;

  Future<void> _editar(BuildContext context, Persona persona) async {
    final editada = await Navigator.of(context).push<Persona>(
      MaterialPageRoute(builder: (_) => FormularioPersona(inicial: persona)),
    );
    if (editada != null && context.mounted) AppScope.of(context).guardarPersona(editada);
  }

  Future<void> _eliminar(BuildContext context, Persona persona) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Eliminar carta'),
        content: Text('¿Eliminar la carta de ${persona.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      AppScope.of(context).eliminarPersona(persona.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final persona = state.buscar(personaId);
    if (persona == null) return const Scaffold();
    final carta = state.cartaDe(persona);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(persona.nombre, overflow: TextOverflow.ellipsis),
            Text(formatoFecha.format(persona.nacimiento), style: Theme.of(context).textTheme.bodySmall),
          ]),
          actions: [
            IconButton(tooltip: 'Editar', icon: const Icon(Icons.edit_outlined), onPressed: () => _editar(context, persona)),
            IconButton(tooltip: 'Eliminar', icon: const Icon(Icons.delete_outline), onPressed: () => _eliminar(context, persona)),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [Tab(text: 'Núcleo'), Tab(text: 'Ciclos'), Tab(text: 'Nombre'), Tab(text: 'Lectura')],
          ),
        ),
        body: TabBarView(children: [
          _Nucleo(carta: carta),
          _Ciclos(carta: carta),
          _Nombre(carta: carta),
          _Lectura(carta: carta),
        ]),
      ),
    );
  }
}

/// Contenedor común de las pestañas: ancho máximo legible y separación entre tarjetas.
class _Pestana extends StatelessWidget {
  const _Pestana({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => Center(
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: children[i]),
      ),
    );
  }
}

// ---------------------------------------------------------------- Núcleo

class _Nucleo extends StatelessWidget {
  const _Nucleo({required this.carta});

  final Carta carta;

  @override
  Widget build(BuildContext context) {
    final c = carta;
    final items = [
      ('Camino de Vida', c.caminoVida, 'Mes ${c.mes.valor} + día ${c.dia.valor} + año ${c.ano.valor} = ${c.caminoVida.bruto}'),
      ('Expresión', c.expresion.reduccion, _sumaPalabras(c.expresion)),
      ('Impulso del Alma', c.alma.reduccion, _sumaPalabras(c.alma)),
      ('Personalidad', c.personalidad.reduccion, _sumaPalabras(c.personalidad)),
      ('Cumpleaños', c.cumpleanos, 'Día ${c.persona.nacimiento.day}'),
      ('Madurez', c.madurez, 'Camino de Vida ${c.caminoVida.valor} + Expresión ${c.expresion.reduccion.valor}'),
    ];
    return _Pestana(children: [
      if (!c.nombreValido) const AvisoSimbolico(texto: 'El nombre no tiene letras válidas: edítalo para calcular los números del nombre.'),
      LayoutBuilder(builder: (context, constraints) {
        final columnas = constraints.maxWidth > 520 ? 3 : 2;
        return GridView.count(
          crossAxisCount: columnas,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: [
            for (final (titulo, r, calculo) in items)
              _TarjetaNumero(titulo: titulo, reduccion: r, calculo: calculo, destacado: titulo == 'Camino de Vida'),
          ],
        );
      }),
      if (c.deudas.isNotEmpty)
        Seccion(
          titulo: 'Deudas kármicas',
          icono: Icons.history_edu_outlined,
          subtitulo: 'Aparecen antes de la reducción final y se leen como "lecciones pendientes".',
          child: Column(children: [
            for (final e in c.deudas.entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: NumeroCirculo('${e.value}', tamano: 40),
                title: Text(e.key),
                subtitle: Text(deudasKarmicas[e.value]!),
              ),
          ]),
        ),
      Seccion(
        titulo: 'Comprobación',
        icono: Icons.check_circle_outline,
        subtitulo: 'Alma + Personalidad debe dar la Expresión (suma directa de letras).',
        child: Text(
          '${c.alma.sumaDirecta} + ${c.personalidad.sumaDirecta} = ${c.alma.sumaDirecta + c.personalidad.sumaDirecta}'
          '   ·   Expresión: ${c.expresion.sumaDirecta}  '
          '${c.alma.sumaDirecta + c.personalidad.sumaDirecta == c.expresion.sumaDirecta ? '✓' : '✗'}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      const AvisoSimbolico(),
    ]);
  }
}

String _sumaPalabras(NumeroNombre n) {
  if (n.palabras.isEmpty) return 'Sin letras';
  return '${n.palabras.map((p) => p.reduccion.valor).join(' + ')} = ${n.reduccion.bruto}';
}

class _TarjetaNumero extends StatelessWidget {
  const _TarjetaNumero({required this.titulo, required this.reduccion, required this.calculo, this.destacado = false});

  final String titulo;
  final Reduccion reduccion;
  final String calculo;
  final bool destacado;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final arq = arquetipoDe(reduccion.valor);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: destacado ? cs.primaryContainer.withValues(alpha: 0.45) : null,
      child: InkWell(
        onTap: () => mostrarSignificado(context, titulo: titulo, numero: reduccion.valor, reduccion: reduccion, calculo: calculo),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(titulo, style: tt.labelLarge, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            NumeroCirculo(reduccion.etiqueta, tamano: 60, maestro: reduccion.esMaestro),
            const SizedBox(height: 10),
            if (arq != null) ...[
              Text(arq.nombre, style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2),
              Text(arq.palabraClave, style: tt.labelSmall?.copyWith(color: cs.tertiary)),
            ],
          ]),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Ciclos

class _Ciclos extends StatefulWidget {
  const _Ciclos({required this.carta});

  final Carta carta;

  @override
  State<_Ciclos> createState() => _CiclosState();
}

class _CiclosState extends State<_Ciclos> {
  final _hoy = DateTime.now();
  late int _ano = _hoy.year;

  @override
  Widget build(BuildContext context) {
    final c = widget.carta;
    final tt = Theme.of(context).textTheme;
    final ap = c.anoPersonal(_ano);
    final au = Carta.anoUniversal(_ano);
    final activo = c.indicePinaculoActivo(_hoy);
    final edad = c.edadEn(_hoy);
    final pinaculos = c.pinaculos;

    Widget ciclo(String titulo, Reduccion r, String calculo, {String? clave}) => Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => mostrarSignificado(context,
                titulo: titulo, numero: r.valor, reduccion: r, calculo: calculo, definicionClave: clave ?? titulo),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(children: [
                NumeroCirculo('${r.valor}', tamano: 48),
                const SizedBox(height: 6),
                Text(titulo, style: tt.labelMedium, textAlign: TextAlign.center),
                Text(arquetipoDe(r.valor)?.palabraClave ?? '', style: tt.labelSmall?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
              ]),
            ),
          ),
        );

    return _Pestana(children: [
      Seccion(
        titulo: 'Tu año',
        icono: Icons.calendar_month_outlined,
        subtitulo: 'Ciclo de 9 años: el 1 inicia, el 5 trae cambio, el 9 cierra.',
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(onPressed: () => setState(() => _ano--), icon: const Icon(Icons.chevron_left)),
            Text('$_ano', style: tt.titleLarge),
            IconButton(onPressed: () => setState(() => _ano++), icon: const Icon(Icons.chevron_right)),
          ]),
          Row(children: [
            ciclo('Año Personal', ap, 'Mes ${c.mes.valor} + día ${c.dia.valor} + año $_ano → ${au.valor} = ${ap.bruto}'),
            ciclo('Año Universal', au, '$_ano'),
          ]),
          if (_ano == _hoy.year) ...[
            const Divider(height: 24),
            Text('Hoy', style: tt.labelLarge),
            Row(children: [
              ciclo('Mes Personal', c.mesPersonal(_hoy), 'Año Personal ${ap.valor} + mes ${_hoy.month}'),
              ciclo('Día Personal', c.diaPersonal(_hoy), 'Mes Personal ${c.mesPersonal(_hoy).valor} + día ${_hoy.day}'),
            ]),
          ],
        ]),
      ),
      Seccion(
        titulo: 'Pináculos',
        icono: Icons.landscape_outlined,
        subtitulo: 'Las cuatro grandes etapas de la vida. M = ${c.mes.base}, D = ${c.dia.base}, A = ${c.ano.base}. '
            'Tienes $edad años.',
        child: Column(children: [
          for (var i = 0; i < pinaculos.length; i++)
            _FilaEtapa(
              titulo: '${i + 1}.º pináculo',
              detalle: '${pinaculos[i].formula} · ${pinaculos[i].edades} años',
              reduccion: pinaculos[i].numero,
              activo: i == activo,
              definicionClave: 'Pináculo',
            ),
        ]),
      ),
      Seccion(
        titulo: 'Desafíos',
        icono: Icons.terrain_outlined,
        subtitulo: 'Los obstáculos de cada etapa. Se restan: es el único lugar donde aparece el 0.',
        child: Column(children: [
          for (final d in c.desafios)
            _FilaEtapa(
              titulo: d.nombre,
              detalle: d.formula,
              reduccion: reducir(d.valor),
              definicionClave: 'Desafío',
            ),
        ]),
      ),
    ]);
  }
}

class _FilaEtapa extends StatelessWidget {
  const _FilaEtapa({
    required this.titulo,
    required this.detalle,
    required this.reduccion,
    required this.definicionClave,
    this.activo = false,
  });

  final String titulo;
  final String detalle;
  final Reduccion reduccion;
  final String definicionClave;
  final bool activo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final arq = arquetipoDe(reduccion.valor);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: activo ? cs.primaryContainer.withValues(alpha: 0.6) : null,
      leading: NumeroCirculo(reduccion.etiqueta, tamano: 44, maestro: reduccion.esMaestro),
      title: Text(activo ? '$titulo · etapa actual' : titulo),
      subtitle: Text('$detalle\n${arq?.nombre ?? 'Sin obstáculo concreto'}'),
      isThreeLine: true,
      onTap: () => mostrarSignificado(context,
          titulo: titulo, numero: reduccion.valor, reduccion: reduccion, calculo: detalle, definicionClave: definicionClave),
    );
  }
}

// ---------------------------------------------------------------- Nombre

class _Nombre extends StatelessWidget {
  const _Nombre({required this.carta});

  final Carta carta;

  Tabla _tablaDe(NumeroNombre n) => Tabla(
        ['Palabra', 'Valores', 'Suma', 'Reducido'],
        [
          for (final p in n.palabras)
            [p.palabra, p.letras.map((l) => '${l.caracter}${l.valor}').join(' '), '${p.suma}', p.reduccion.etiqueta],
          ['Total', '', '${n.sumaDirecta}', '${n.reduccion.bruto} → ${n.reduccion.etiqueta}'],
        ],
      );

  @override
  Widget build(BuildContext context) {
    final c = carta;
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final usoCaldeo = (c.persona.nombreUso?.isNotEmpty ?? false) ? c.persona.nombreUso! : c.persona.nombre;
    return _Pestana(children: [
      Seccion(
        titulo: 'Expresión · todas las letras',
        icono: Icons.text_fields,
        subtitulo: 'Cada palabra se reduce por separado (respetando maestros) y luego se suman.',
        child: TablaSimple(_tablaDe(c.expresion)),
      ),
      Seccion(
        titulo: 'Impulso del Alma · vocales',
        icono: Icons.favorite_outline,
        subtitulo: 'Letra Y: ${c.ajustes.modoY.descripcion.toLowerCase()} (se cambia en Ajustes).',
        child: TablaSimple(_tablaDe(c.alma)),
      ),
      Seccion(
        titulo: 'Personalidad · consonantes',
        icono: Icons.face_outlined,
        child: TablaSimple(_tablaDe(c.personalidad)),
      ),
      Seccion(
        titulo: 'Tabla de inclusión',
        icono: Icons.grid_on,
        subtitulo: 'Cuántas veces aparece cada número en el nombre. Un número ausente es una "lección kármica".',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              for (var n = 1; n <= 9; n++)
                Container(
                  decoration: BoxDecoration(
                    color: c.inclusion[n] == 0
                        ? cs.errorContainer.withValues(alpha: 0.5)
                        : c.numerosIntensos.contains(n)
                            ? cs.tertiaryContainer
                            : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: '$n', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    TextSpan(text: '  ×${c.inclusion[n]}', style: tt.bodyMedium),
                  ])),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            c.leccionesKarmicas.isEmpty
                ? 'No hay lecciones kármicas: todos los números aparecen.'
                : 'Lecciones kármicas: ${c.leccionesKarmicas.map((n) => '$n (${arquetipos[n]!.palabraClave.toLowerCase()})').join(', ')}.',
            style: tt.bodyMedium,
          ),
          if (c.numerosIntensos.isNotEmpty)
            Text('Más frecuente: ${c.numerosIntensos.join(', ')}.', style: tt.bodyMedium),
        ]),
      ),
      Seccion(
        titulo: 'Planos de expresión',
        icono: Icons.layers_outlined,
        subtitulo: 'Reparto de las letras según su número (convención usada en esta app).',
        child: Column(children: [
          for (final p in c.planos)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                SizedBox(width: 90, child: Text(p.nombre, style: tt.bodyMedium)),
                Expanded(
                  child: LinearProgressIndicator(
                    value: c.palabras.isEmpty ? 0 : p.cantidad / c.palabras.fold<int>(0, (s, w) => s + w.letras.length),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 64, child: Text('  ${p.cantidad} (${p.numeros.join(',')})', style: tt.bodySmall)),
              ]),
            ),
        ]),
      ),
      Seccion(
        titulo: 'Números puente',
        icono: Icons.compare_arrows,
        subtitulo: 'La diferencia entre dos números núcleo: lo que ayuda a acercarlos.',
        child: Column(children: [
          for (final p in c.puentes)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: NumeroCirculo('${p.valor}', tamano: 40),
              title: Text(p.entre),
              subtitle: Text(arquetipoDe(p.valor)?.palabraClave ?? 'Sin distancia: ya están alineados'),
            ),
        ]),
      ),
      Seccion(
        titulo: 'Comparación con el sistema caldeo',
        icono: Icons.swap_horiz,
        subtitulo: 'Nombre de uso: $usoCaldeo. El caldeo lee el número compuesto antes de reducirlo.',
        child: Row(children: [
          Expanded(
            child: Column(children: [
              NumeroCirculo(c.expresion.reduccion.etiqueta, maestro: c.expresion.reduccion.esMaestro),
              const SizedBox(height: 4),
              Text('Pitagórico', style: tt.labelMedium),
            ]),
          ),
          Expanded(
            child: Column(children: [
              NumeroCirculo(c.caldeo.etiqueta, maestro: c.caldeo.esMaestro),
              const SizedBox(height: 4),
              Text('Caldeo (compuesto ${c.caldeoCompuesto})', style: tt.labelMedium, textAlign: TextAlign.center),
            ]),
          ),
        ]),
      ),
      AvisoSimbolico(
        texto: c.caldeo.valor == c.expresion.reduccion.valor
            ? 'Aquí los dos sistemas coinciden, pero no siempre pasa: la F vale 6 en el pitagórico y 8 en el caldeo.'
            : 'Los dos sistemas dan números distintos para el mismo nombre. ¿Cuál describe a la persona? '
                'Es la pregunta crítica del Módulo 3.',
      ),
    ]);
  }
}

// ---------------------------------------------------------------- Lectura

class _Lectura extends StatelessWidget {
  const _Lectura({required this.carta});

  final Carta carta;

  @override
  Widget build(BuildContext context) {
    final c = carta;
    final tt = Theme.of(context).textTheme;
    final hoy = DateTime.now();
    final cv = arquetipoDe(c.caminoVida.valor);
    final alma = arquetipoDe(c.alma.reduccion.valor);
    final pers = arquetipoDe(c.personalidad.reduccion.valor);
    final ap = c.anoPersonal(hoy.year);
    final apArq = arquetipoDe(ap.valor);
    final indicePinaculo = c.indicePinaculoActivo(hoy);
    final pinaculo = c.pinaculos[indicePinaculo];
    final pinArq = arquetipoDe(pinaculo.numero.valor);
    final repeticiones = c.repeticiones;

    final preguntas = <String>{
      ?cv?.pregunta,
      if (alma != null && pers != null && alma.numero != pers.numero)
        'Por dentro buscas "${alma.palabraClave.toLowerCase()}" y hacia fuera muestras "${pers.palabraClave.toLowerCase()}". '
            '¿Dónde notas esa distancia?',
      ?apArq?.pregunta,
      ?pinArq?.pregunta,
    };

    Widget paso(int n, String titulo, String texto) => Seccion(
          titulo: '$n. $titulo',
          child: Text(texto, style: tt.bodyMedium),
        );

    return _Pestana(children: [
      const AvisoSimbolico(
        texto: 'Lectura guiada con el método del numerólogo (Módulo 6). Está formulada como preguntas, '
            'no como sentencias: el valor de la numerología está en la reflexión que provoca.',
      ),
      if (cv != null)
        paso(1, 'El tema: Camino de Vida ${c.caminoVida.etiqueta}',
            '${cv.nombre}. En su luz: ${cv.luz.toLowerCase()}. En su sombra: ${cv.sombra.toLowerCase()}.'
            '${c.caminoVida.deudaKarmica != null ? ' Con deuda kármica ${c.caminoVida.deudaKarmica}: ${deudasKarmicas[c.caminoVida.deudaKarmica]!.toLowerCase()}.' : ''}'),
      if (alma != null && pers != null)
        paso(
            2,
            'Lo que quieres y lo que muestras',
            'Impulso del Alma ${c.alma.reduccion.etiqueta} (${alma.nombre.toLowerCase()}) frente a '
                'Personalidad ${c.personalidad.reduccion.etiqueta} (${pers.nombre.toLowerCase()}). '
                '${alma.numero == pers.numero ? 'Coinciden: lo que deseas y lo que muestras van en la misma dirección.' : 'La tensión entre ambos es la conversación más rica de la carta. Número puente: ${c.puentes.first.valor}.'}'),
      paso(
          3,
          'Repeticiones',
          repeticiones.isEmpty
              ? 'Ningún número se repite entre los seis núcleo: la carta es variada.'
              : repeticiones.entries
                  .map((e) =>
                      'El ${e.key} (${arquetipos[e.key]!.palabraClave.toLowerCase()}) aparece ${e.value.length} veces: ${e.value.join(', ')}'
                      '${e.value.length >= 3 ? '. Se lee como dominante' : ''}.')
                  .join('\n')),
      if (apArq != null && pinArq != null)
        paso(4, 'El momento',
            'Año Personal ${hoy.year}: ${ap.valor}, ${apArq.palabraClave.toLowerCase()} (${apArq.luz.toLowerCase()}). '
            'Estás en el ${indicePinaculo + 1}.º pináculo (${pinaculo.edades} años), un ${pinaculo.numero.etiqueta}: '
            '${pinArq.nombre.toLowerCase()}.'),
      Seccion(
        titulo: '5. Preguntas para reflexionar',
        child: Column(children: [
          for (final p in preguntas)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.help_outline),
              title: Text(p, style: tt.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
            ),
        ]),
      ),
      const AvisoSimbolico(
        texto: 'Mirada crítica: casi todos los arquetipos describen rasgos que cualquiera reconoce en sí mismo '
            'en algún momento (efecto Barnum). Lee esto como un espejo para conversar, no como un diagnóstico.',
      ),
    ]);
  }
}
