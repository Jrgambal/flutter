import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import 'state/app_state.dart';
import 'ui/pantalla_aprender.dart';
import 'ui/pantalla_cartas.dart';
import 'ui/pantalla_numeros.dart';
import 'ui/tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  final state = AppState()..cargar();
  runApp(NumerologiaApp(state: state));
}

class NumerologiaApp extends StatelessWidget {
  const NumerologiaApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'Numerología',
        debugShowCheckedModeBanner: false,
        theme: temaClaro,
        darkTheme: temaOscuro,
        locale: const Locale('es'),
        supportedLocales: const [Locale('es'), Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const Inicio(),
      ),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _pestana = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pestana,
        children: const [PantallaCartas(), PantallaNumeros(), PantallaAprender()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pestana,
        onDestinationSelected: (i) => setState(() => _pestana = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Cartas'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Números'),
          NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Aprender'),
        ],
      ),
    );
  }
}
