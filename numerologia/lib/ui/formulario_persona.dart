import 'package:material_ui/material_ui.dart';

import '../core/carta.dart';
import '../core/letras.dart';
import '../state/app_state.dart';
import 'pantalla_cartas.dart' show formatoFecha;

/// Alta o edición de una persona. Devuelve la [Persona] al guardar.
class FormularioPersona extends StatefulWidget {
  const FormularioPersona({super.key, this.inicial});

  final Persona? inicial;

  @override
  State<FormularioPersona> createState() => _FormularioPersonaState();
}

class _FormularioPersonaState extends State<FormularioPersona> {
  final _form = GlobalKey<FormState>();
  late final _nombre = TextEditingController(text: widget.inicial?.nombre);
  late final _uso = TextEditingController(text: widget.inicial?.nombreUso);
  late DateTime? _fecha = widget.inicial?.nacimiento;
  bool _fechaFaltante = false;

  @override
  void dispose() {
    _nombre.dispose();
    _uso.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? DateTime(hoy.year - 30),
      firstDate: DateTime(1900),
      lastDate: hoy,
      initialEntryMode: DatePickerEntryMode.input,
      helpText: 'Fecha de nacimiento',
      fieldLabelText: 'Fecha (dd/mm/aaaa)',
    );
    if (elegida != null) {
      setState(() {
        _fecha = elegida;
        _fechaFaltante = false;
      });
    }
  }

  void _guardar() {
    final valido = _form.currentState!.validate();
    setState(() => _fechaFaltante = _fecha == null);
    if (!valido || _fecha == null) return;
    final uso = _uso.text.trim();
    Navigator.of(context).pop(Persona(
      id: widget.inicial?.id ?? AppState.nuevoId(),
      nombre: _nombre.text.trim().replaceAll(RegExp(r'\s+'), ' '),
      nombreUso: uso.isEmpty ? null : uso,
      nacimiento: _fecha!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.inicial == null ? 'Nueva carta' : 'Editar datos')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombre,
              autofocus: widget.inicial == null,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo de nacimiento',
                helperText: 'Todos los nombres y apellidos, como en el acta de nacimiento',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final palabras = analizarNombre(v ?? '', const Ajustes());
                if (palabras.isEmpty) return 'Escribe el nombre completo';
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _elegirFecha,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                  errorText: _fechaFaltante ? 'Elige la fecha de nacimiento' : null,
                ),
                child: Text(
                  _fecha == null ? 'Elegir fecha' : formatoFecha.format(_fecha!),
                  style: _fecha == null ? TextStyle(color: cs.onSurfaceVariant) : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _uso,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre de uso diario (opcional)',
                helperText: 'El sistema caldeo usa el nombre con el que te llaman',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _guardar, child: const Text('Calcular carta')),
          ],
        ),
      ),
    );
  }
}
