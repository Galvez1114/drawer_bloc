import 'dart:js';

import 'package:drawer_bloc/bloc/opcionesBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => OpcionesBloc()..add(YaInicializado()),
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
                Opciones(),
                Parametros(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Opciones extends StatelessWidget {
  const Opciones({super.key});

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
            onTap: () => context.read<OpcionesBloc>().add(CambioANumero()),
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

class Parametros extends StatelessWidget {
  const Parametros({super.key});

  @override
  Widget build(BuildContext context) {
    var estado = context.watch<OpcionesBloc>().state;
    return switch (estado) {
      Estados.numeroSeleccionado => const OpcionesNumeros(),
      Estados.colorSeleccionado => const OpcionesColor(),
      Estados.inicial => const CircularProgressIndicator(),
    };
  }
}

class OpcionesNumeros extends StatefulWidget {
  const OpcionesNumeros({super.key});

  @override
  State<OpcionesNumeros> createState() => _OpcionesNumerosState();
}

class _OpcionesNumerosState extends State<OpcionesNumeros> {
  late final TextEditingController controlador;

  @override
  void initState() {
    super.initState();
    controlador = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int n = context.watch<OpcionesBloc>().datos.numeroInicial;
    controlador.text = '$n';
    return Expanded(
      child: TextField(
        controller: controlador,
        decoration: const InputDecoration(label: Text('Numero inicial')),
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          int numero = int.tryParse(value) ?? 0;
          context
              .read<OpcionesBloc>()
              .add(CambioDeNumero(numeroInicial: numero));
        },
      ),
    );
  }
}

class OpcionesColor extends StatelessWidget {
  const OpcionesColor({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const TextField();
  }
}
