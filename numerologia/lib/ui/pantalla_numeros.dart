import 'package:material_ui/material_ui.dart';

import '../data/significados.dart';
import 'widgets.dart';

/// Diccionario de arquetipos y deudas kármicas (Módulo 6).
class PantallaNumeros extends StatelessWidget {
  const PantallaNumeros({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Significado de los números')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const AvisoSimbolico(
                texto: 'Cada número es un arquetipo con una cara luminosa y una sombra. Son convenciones de la '
                    'tradición Balliett-Jordan, no hallazgos.',
              ),
              const SizedBox(height: 16),
              Text('Números base', style: tt.titleMedium),
              const SizedBox(height: 8),
              for (var n = 1; n <= 9; n++) _TarjetaArquetipo(arquetipos[n]!),
              const SizedBox(height: 16),
              Text('Números maestros', style: tt.titleMedium),
              Text('Si una suma da 11, 22 o 33, no se reduce.', style: tt.bodySmall),
              const SizedBox(height: 8),
              for (final n in [11, 22, 33]) _TarjetaArquetipo(arquetipos[n]!),
              const SizedBox(height: 16),
              Text('Números de deuda kármica', style: tt.titleMedium),
              Text('13, 14, 16 o 19 antes de la reducción final.', style: tt.bodySmall),
              const SizedBox(height: 8),
              Card(
                child: Column(children: [
                  for (final e in deudasKarmicas.entries)
                    ListTile(
                      leading: NumeroCirculo('${e.key}/${e.key % 9 == 0 ? 9 : e.key % 9}', tamano: 44),
                      title: Text(e.value),
                    ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaArquetipo extends StatelessWidget {
  const _TarjetaArquetipo(this.a);

  final Arquetipo a;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => mostrarSignificado(context, titulo: 'Número ${a.etiqueta}', numero: a.numero, etiqueta: a.etiqueta),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              NumeroCirculo(a.etiqueta, tamano: 52, maestro: a.esMaestro),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(a.nombre, style: tt.titleSmall)),
                    Text(a.palabraClave, style: tt.labelMedium?.copyWith(color: cs.tertiary)),
                  ]),
                  const SizedBox(height: 4),
                  Text('☀ ${a.luz}', style: tt.bodySmall),
                  Text('☾ ${a.sombra}', style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
