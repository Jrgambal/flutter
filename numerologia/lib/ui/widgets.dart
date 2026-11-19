import 'package:material_ui/material_ui.dart';

import '../core/reduccion.dart';
import '../data/curso.dart';
import '../data/significados.dart';

/// Un número dentro de un círculo; los maestros se resaltan en dorado.
class NumeroCirculo extends StatelessWidget {
  const NumeroCirculo(this.texto, {super.key, this.tamano = 56, this.maestro = false});

  final String texto;
  final double tamano;
  final bool maestro;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fondo = maestro ? cs.tertiaryContainer : cs.primaryContainer;
    final frente = maestro ? cs.onTertiaryContainer : cs.onPrimaryContainer;
    return Container(
      width: tamano,
      height: tamano,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fondo,
        shape: BoxShape.circle,
        border: maestro ? Border.all(color: cs.tertiary, width: 2) : null,
      ),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            texto,
            style: TextStyle(fontSize: tamano * 0.4, fontWeight: FontWeight.w700, color: frente),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta con título para agrupar contenido.
class Seccion extends StatelessWidget {
  const Seccion({super.key, required this.titulo, required this.child, this.subtitulo, this.icono});

  final String titulo;
  final String? subtitulo;
  final IconData? icono;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              if (icono != null) ...[
                Icon(icono, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(titulo, style: tt.titleMedium)),
            ]),
            if (subtitulo != null) ...[
              const SizedBox(height: 4),
              Text(subtitulo!, style: tt.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Aviso del enfoque del curso: herramienta simbólica, no ciencia.
class AvisoSimbolico extends StatelessWidget {
  const AvisoSimbolico({super.key, this.texto});

  final String? texto;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.lightbulb_outline, size: 18, color: cs.onSecondaryContainer),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto ??
                'La numerología es un sistema simbólico, no una ciencia. Úsala para hacerte preguntas, '
                    'no para tomar decisiones de salud, dinero o relaciones.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSecondaryContainer),
          ),
        ),
      ]),
    );
  }
}

/// Tabla simple a partir de encabezados y filas, con desplazamiento horizontal si no cabe.
class TablaSimple extends StatelessWidget {
  const TablaSimple(this.tabla, {super.key, this.resaltarFila});

  final Tabla tabla;
  final int? resaltarFila;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final columnas = tabla.encabezados.length;
    final compacta = columnas > 4;
    Widget celda(String t, {bool encabezado = false}) => Padding(
          padding: EdgeInsets.symmetric(horizontal: compacta ? 4 : 8, vertical: 8),
          child: Text(
            t,
            textAlign: compacta ? TextAlign.center : TextAlign.start,
            style: encabezado ? tt.labelMedium?.copyWith(fontWeight: FontWeight.w700) : tt.bodySmall,
          ),
        );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Table(
        border: TableBorder(horizontalInside: BorderSide(color: cs.outlineVariant, width: 0.5)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: compacta ? null : {0: const IntrinsicColumnWidth(flex: 1)},
        children: [
          TableRow(
            decoration: BoxDecoration(color: cs.surfaceContainerHighest),
            children: [for (final e in tabla.encabezados) celda(e, encabezado: true)],
          ),
          for (var i = 0; i < tabla.filas.length; i++)
            TableRow(
              decoration: i == resaltarFila ? BoxDecoration(color: cs.primaryContainer.withValues(alpha: 0.6)) : null,
              children: [for (var c = 0; c < columnas; c++) celda(c < tabla.filas[i].length ? tabla.filas[i][c] : '')],
            ),
        ],
      ),
    );
  }
}

/// Hoja inferior con el significado de un número y cómo se calculó.
Future<void> mostrarSignificado(
  BuildContext context, {
  required String titulo,
  required int numero,
  String? etiqueta,
  Reduccion? reduccion,
  String? calculo,
  String? definicionClave,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scroll) => _HojaSignificado(
        scroll: scroll,
        titulo: titulo,
        numero: numero,
        etiqueta: etiqueta ?? reduccion?.etiqueta ?? '$numero',
        reduccion: reduccion,
        calculo: calculo,
        definicion: definiciones[definicionClave ?? titulo],
      ),
    ),
  );
}

class _HojaSignificado extends StatelessWidget {
  const _HojaSignificado({
    required this.scroll,
    required this.titulo,
    required this.numero,
    required this.etiqueta,
    this.reduccion,
    this.calculo,
    this.definicion,
  });

  final ScrollController scroll;
  final String titulo;
  final int numero;
  final String etiqueta;
  final Reduccion? reduccion;
  final String? calculo;
  final DefinicionNumero? definicion;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final arq = arquetipoDe(numero);
    final deuda = reduccion?.deudaKarmica;
    return ListView(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Row(children: [
          NumeroCirculo(etiqueta, tamano: 64, maestro: arq?.esMaestro ?? false),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titulo, style: tt.titleLarge),
              if (arq != null) Text(arq.nombre, style: tt.titleSmall?.copyWith(color: cs.primary)),
            ]),
          ),
        ]),
        if (definicion != null) ...[
          const SizedBox(height: 16),
          Text(definicion!.representa, style: tt.bodyMedium),
          Text('Se calcula con: ${definicion!.seCalculaCon}',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        ],
        if (calculo != null || (reduccion != null && reduccion!.cadena.length > 1)) ...[
          const SizedBox(height: 16),
          Text('Cálculo', style: tt.labelLarge),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
            child: Text(
              [?calculo, if (reduccion != null && reduccion!.cadena.length > 1) reduccion!.pasos].join('\n'),
              style: tt.bodyMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ),
        ],
        if (numero == 0) ...[
          const SizedBox(height: 16),
          Text(desafioCero, style: tt.bodyMedium),
        ],
        if (arq != null) ...[
          const SizedBox(height: 16),
          _Rasgo(icono: Icons.wb_sunny_outlined, titulo: 'Luz', texto: arq.luz),
          _Rasgo(icono: Icons.nights_stay_outlined, titulo: 'Sombra', texto: arq.sombra),
          _Rasgo(icono: Icons.key_outlined, titulo: 'Palabra clave', texto: arq.palabraClave),
          if (arq.esMaestro)
            _Rasgo(
              icono: Icons.auto_awesome_outlined,
              titulo: 'Número maestro',
              texto: 'No se reduce. Se lee con la intensidad del maestro y la base del ${arq.etiqueta.split('/').last}.',
            ),
        ],
        if (deuda != null)
          _Rasgo(
            icono: Icons.history_edu_outlined,
            titulo: 'Deuda kármica $deuda',
            texto: deudasKarmicas[deuda]!,
          ),
        if (arq != null) ...[
          const SizedBox(height: 12),
          Card(
            color: cs.primaryContainer.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Icon(Icons.help_outline, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(arq.pregunta, style: tt.bodyLarge?.copyWith(fontStyle: FontStyle.italic))),
              ]),
            ),
          ),
        ],
        const SizedBox(height: 16),
        const AvisoSimbolico(
          texto: 'Estos significados son convenciones de la tradición Balliett-Jordan, no hallazgos. '
              'Casi cualquiera se reconoce en ellos (efecto Barnum).',
        ),
      ],
    );
  }
}

class _Rasgo extends StatelessWidget {
  const _Rasgo({required this.icono, required this.titulo, required this.texto});

  final IconData icono;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icono, size: 20, color: Theme.of(context).colorScheme.tertiary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titulo, style: tt.labelLarge),
            Text(texto, style: tt.bodyMedium),
          ]),
        ),
      ]),
    );
  }
}
