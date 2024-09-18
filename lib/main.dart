import 'package:drawer_bloc/bloc/opcionesBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => OpcionesBloc(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(border: Border.all(color: Colors.green)),
            child: const Row(
              children: [
                opciones(),
                parametros(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class opciones extends StatelessWidget {
  const opciones({super.key});

  @override
  Widget build(BuildContext context) {
    var estado = context.watch<OpcionesBloc>().state;
    return Expanded(
      child: Column(
        children: [
          ListTile(
            selected: estado == Estados.numeroSeleccionado,
            title: const Text('Numeros'),
            leading: const Icon(Icons.numbers),
            onTap: () => context.read<OpcionesBloc>().add(cambioANumero()),
          ),
          ListTile(
            selected: estado == Estados.colorSeleccionado,
            title: const Text('Colores'),
            leading: const Icon(Icons.colorize),
            onTap: () => context.read<OpcionesBloc>().add(CambioAColor()),
          ),
        ],
      ),
    );
  }
}

class parametros extends StatelessWidget {
  const parametros({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: Column());
  }
}
