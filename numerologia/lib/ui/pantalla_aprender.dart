import 'package:material_ui/material_ui.dart';

import '../data/curso.dart';
import 'widgets.dart';

/// El curso completo: módulos y evaluación final.
class PantallaAprender extends StatelessWidget {
  const PantallaAprender({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Curso de numerología')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(presentacion, style: tt.bodyMedium),
              const SizedBox(height: 16),
              for (final m in modulos)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cs.primaryContainer,
                        foregroundColor: cs.onPrimaryContainer,
                        child: Text('${m.numero}'),
                      ),
                      title: Text(m.titulo),
                      subtitle: Text(m.resumen),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PantallaModulo(m))),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PantallaEvaluacion())),
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('Evaluación final (10 preguntas)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PantallaModulo extends StatelessWidget {
  const PantallaModulo(this.modulo, {super.key});

  final Modulo modulo;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Módulo ${modulo.numero}')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(modulo.titulo, style: tt.headlineSmall),
              const SizedBox(height: 4),
              Text(modulo.resumen, style: tt.bodyMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              for (final b in modulo.bloques) Padding(padding: const EdgeInsets.only(top: 12), child: _bloque(context, b)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bloque(BuildContext context, Bloque b) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    switch (b) {
      case Parrafo(:final titulo, :final texto):
        return Text.rich(TextSpan(children: [
          if (titulo != null) TextSpan(text: '$titulo. ', style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: texto),
        ]), style: tt.bodyMedium);
      case Subtitulo(:final texto):
        return Padding(padding: const EdgeInsets.only(top: 8), child: Text(texto, style: tt.titleMedium));
      case Vinetas(:final items, :final numeradas):
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 24, child: Text(numeradas ? '${i + 1}.' : '•', style: tt.bodyMedium)),
                Expanded(child: Text(items[i], style: tt.bodyMedium)),
              ]),
            ),
        ]);
      case Tabla():
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width.clamp(0, 720) - 32, maxWidth: 720),
            child: TablaSimple(b),
          ),
        );
      case Destacado(:final texto, :final critico):
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: critico ? cs.tertiaryContainer.withValues(alpha: 0.6) : cs.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(critico ? Icons.psychology_alt_outlined : Icons.lightbulb_outline, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(TextSpan(children: [
                if (critico) const TextSpan(text: 'Mirada crítica. ', style: TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: texto),
              ]), style: tt.bodyMedium),
            ),
          ]),
        );
    }
  }
}

class PantallaEvaluacion extends StatefulWidget {
  const PantallaEvaluacion({super.key});

  @override
  State<PantallaEvaluacion> createState() => _PantallaEvaluacionState();
}

class _PantallaEvaluacionState extends State<PantallaEvaluacion> {
  final _respuestas = <int, int>{};

  int get _aciertos => _respuestas.entries.where((e) => evaluacion[e.key].correcta == e.value).length;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final terminado = _respuestas.length == evaluacion.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación final'),
        actions: [
          Center(child: Padding(padding: const EdgeInsets.only(right: 16), child: Text('$_aciertos/${evaluacion.length}'))),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              for (var i = 0; i < evaluacion.length; i++) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${i + 1}. ${evaluacion[i].enunciado}', style: tt.titleSmall),
                      const SizedBox(height: 8),
                      for (var o = 0; o < evaluacion[i].opciones.length; o++)
                        _Opcion(
                          texto: evaluacion[i].opciones[o],
                          estado: !_respuestas.containsKey(i)
                              ? null
                              : o == evaluacion[i].correcta
                                  ? true
                                  : o == _respuestas[i]
                                      ? false
                                      : null,
                          onTap: _respuestas.containsKey(i) ? null : () => setState(() => _respuestas[i] = o),
                        ),
                      if (_respuestas.containsKey(i)) ...[
                        const SizedBox(height: 8),
                        Text(evaluacion[i].explicacion, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (terminado)
                Card(
                  color: cs.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      Text('Resultado: $_aciertos de ${evaluacion.length}', style: tt.titleLarge),
                      const SizedBox(height: 8),
                      TextButton(onPressed: () => setState(_respuestas.clear), child: const Text('Repetir')),
                    ]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({required this.texto, required this.estado, required this.onTap});

  final String texto;

  /// true = correcta, false = elegida e incorrecta, null = neutra.
  final bool? estado;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = switch (estado) { true => Colors.green, false => cs.error, null => null };
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: OutlinedButton(
        onPressed: onTap ?? () {},
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          side: BorderSide(color: color ?? cs.outlineVariant, width: color == null ? 1 : 2),
          foregroundColor: color ?? cs.onSurface,
        ),
        child: Row(children: [
          Expanded(child: Text(texto)),
          if (estado == true) const Icon(Icons.check_circle, color: Colors.green, size: 20),
          if (estado == false) Icon(Icons.cancel, color: cs.error, size: 20),
        ]),
      ),
    );
  }
}
