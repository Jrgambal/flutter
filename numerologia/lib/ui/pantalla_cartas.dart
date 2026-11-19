import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../core/carta.dart';
import '../state/app_state.dart';
import 'formulario_persona.dart';
import 'pantalla_ajustes.dart';
import 'pantalla_carta.dart';
import 'widgets.dart';

final formatoFecha = DateFormat('d MMM y', 'es');

class PantallaCartas extends StatelessWidget {
  const PantallaCartas({super.key});

  Future<void> _nueva(BuildContext context) async {
    final persona = await Navigator.of(context).push<Persona>(
      MaterialPageRoute(builder: (_) => const FormularioPersona()),
    );
    if (persona != null && context.mounted) {
      AppScope.of(context).guardarPersona(persona);
      abrirCarta(context, persona.id);
    }
  }

  void _ejemplo(BuildContext context) {
    final persona = Persona(
      id: AppState.nuevoId(),
      nombre: 'Ana María López Ruiz',
      nacimiento: DateTime(1990, 7, 14),
    );
    AppScope.of(context).guardarPersona(persona);
    abrirCarta(context, persona.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final personas = state.personas;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis cartas'),
        actions: [
          IconButton(
            tooltip: 'Ajustes de cálculo',
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PantallaAjustes())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nueva(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva carta'),
      ),
      body: !state.cargado
          ? const Center(child: CircularProgressIndicator())
          : personas.isEmpty
              ? _Vacio(onNueva: () => _nueva(context), onEjemplo: () => _ejemplo(context))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: personas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _TarjetaPersona(carta: state.cartaDe(personas[i])),
                ),
    );
  }
}

void abrirCarta(BuildContext context, String id) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PantallaCarta(personaId: id)));
}

class _TarjetaPersona extends StatelessWidget {
  const _TarjetaPersona({required this.carta});

  final Carta carta;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final p = carta.persona;
    final ap = carta.anoPersonal(DateTime.now().year);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => abrirCarta(context, p.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            NumeroCirculo(carta.caminoVida.etiqueta, maestro: carta.caminoVida.esMaestro),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.nombre, style: tt.titleMedium),
                const SizedBox(height: 2),
                Text(formatoFecha.format(p.nacimiento), style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  _Chip('Expresión ${carta.expresion.reduccion.etiqueta}'),
                  _Chip('Alma ${carta.alma.reduccion.etiqueta}'),
                  _Chip('Año personal ${ap.valor}'),
                ]),
              ]),
            ),
            const Icon(Icons.chevron_right),
          ]),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
      child: Text(texto, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.onNueva, required this.onEjemplo});

  final VoidCallback onNueva;
  final VoidCallback onEjemplo;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const NumeroCirculo('✦', tamano: 88, maestro: true),
            const SizedBox(height: 24),
            Text('Tu carta numerológica', style: tt.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Con tu nombre completo de nacimiento y tu fecha calculamos los seis números núcleo, '
              'tus ciclos, pináculos y desafíos con el sistema pitagórico, paso a paso.',
              style: tt.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: onNueva, icon: const Icon(Icons.add), label: const Text('Calcular mi carta')),
            const SizedBox(height: 8),
            TextButton(onPressed: onEjemplo, child: const Text('Ver el ejemplo del curso (Ana María López Ruiz)')),
            const SizedBox(height: 24),
            const AvisoSimbolico(),
          ]),
        ),
      ),
    );
  }
}
