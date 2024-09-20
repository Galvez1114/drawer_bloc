import 'package:drawer_bloc/bloc/opcionesBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => OpcionesBloc()..add(YaInicializado()),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Expanded(
          child: Row(
            children: [
              Opciones(),
              Parametros(),
            ],
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
        mainAxisAlignment: MainAxisAlignment.center,
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
    return BlocConsumer<OpcionesBloc, Estados>(
      listener: (context, state) {},
      builder: (context, state) {
        return const Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ColorPickerAlerta(), ColorPickerNormal()],
        ));
      },
    );
  }
}

class ColorPickerNormal extends StatefulWidget {
  const ColorPickerNormal({
    super.key,
  });

  @override
  State<ColorPickerNormal> createState() => _ColorPickerNormalState();
}

class _ColorPickerNormalState extends State<ColorPickerNormal> {
  @override
  Widget build(BuildContext context) {
    Color colorNormal =
        stringToColor(context.watch<OpcionesBloc>().datos.colorNormal);
    return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Elige el color de rango normal!'),
                content: SingleChildScrollView(
                    child: ColorPicker(
                  pickerColor: colorNormal,
                  onColorChanged: (value) {
                    context
                        .read<OpcionesBloc>()
                        .add(cambioDeColorNormal(colorNormal: value));
                    setState(() {
                      colorNormal = value;
                    });
                  },
                )),
                actions: const [BotonCerrarAlertDialog()],
              );
            },
          );
        },
        child: CuerpoBotonColorPicker(
            elColor: colorNormal, mensaje: 'Color normal'));
  }
}

class BotonCerrarAlertDialog extends StatelessWidget {
  const BotonCerrarAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Guardar'));
  }
}

class ColorPickerAlerta extends StatefulWidget {
  const ColorPickerAlerta({super.key});

  @override
  State<ColorPickerAlerta> createState() => _ColorPickerAlertaState();
}

class _ColorPickerAlertaState extends State<ColorPickerAlerta> {
  @override
  Widget build(BuildContext context) {
    Color colorAlerta =
        stringToColor(context.watch<OpcionesBloc>().datos.colorAlerta);
    return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Elige el color de alerta!'),
                  content: SingleChildScrollView(
                      child: ColorPicker(
                    pickerColor: colorAlerta,
                    onColorChanged: (value) {
                      context
                          .read<OpcionesBloc>()
                          .add(cambioDeColorAlerta(colorAlerta: value));
                      setState(() {
                        colorAlerta = value;
                      });
                    },
                  )),
                  actions: const [BotonCerrarAlertDialog()]);
            },
          );
        },
        child: CuerpoBotonColorPicker(
            elColor: colorAlerta, mensaje: 'Color de alerta'));
  }
}

class CuerpoBotonColorPicker extends StatelessWidget {
  const CuerpoBotonColorPicker({
    super.key,
    required this.elColor,
    required this.mensaje,
  });

  final Color elColor;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            mensaje,
          ),
          CircleAvatar(
            backgroundColor: elColor,
            maxRadius: 15,
          )
        ],
      ),
    );
  }
}

Color stringToColor(String hexColor) {
  hexColor = hexColor.replaceFirst('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor'; // Añadir canal alfa si es necesario
  }
  if (hexColor.length > 4) {
    print('se intentó xd');
    return Color(int.parse(hexColor, radix: 16)).withOpacity(1.0);
  } else {
    return const Color(0xff443a49);
  }
}
