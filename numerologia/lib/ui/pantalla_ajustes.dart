import 'package:material_ui/material_ui.dart';

import '../core/letras.dart';
import '../state/app_state.dart';
import 'widgets.dart';

/// Variantes de cálculo entre escuelas (Módulos 3 y 4).
class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final ajustes = state.ajustes;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes de cálculo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Valor de la Ñ', style: tt.titleMedium),
          Text('En español la Ñ suele valer 5 (como la N) o 6, según el autor.', style: tt.bodySmall),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 5, label: Text('Ñ = 5')),
              ButtonSegment(value: 6, label: Text('Ñ = 6')),
            ],
            selected: {ajustes.valorEnie},
            onSelectionChanged: (s) => state.actualizarAjustes(ajustes.copyWith(valorEnie: s.first)),
          ),
          const SizedBox(height: 24),
          Text('La letra Y', style: tt.titleMedium),
          Text('Algunas escuelas la cuentan como vocal cuando suena a "i". Cambia el Alma y la Personalidad, no la Expresión.',
              style: tt.bodySmall),
          const SizedBox(height: 8),
          for (final m in ModoY.values)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(m == ajustes.modoY ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: m == ajustes.modoY ? Theme.of(context).colorScheme.primary : null),
              title: Text(m.descripcion),
              onTap: () => state.actualizarAjustes(ajustes.copyWith(modoY: m)),
            ),
          const SizedBox(height: 24),
          const AvisoSimbolico(
            texto: 'Los acentos se ignoran y la fecha se reduce por partes (mes, día y año). Estas variantes '
                'explican por qué dos numerólogos pueden darle a la misma persona cartas distintas.',
          ),
        ],
      ),
    );
  }
}
