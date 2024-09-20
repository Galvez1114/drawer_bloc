import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _numeroInicial = 'numeroinicial';
const String _colorDeAlerta = 'colorAlerta';
const String _colorNormal = 'colorNormal';

class Datos {
  int numeroInicial;
  String colorAlerta;
  String colorNormal;

  Datos(
      {required this.numeroInicial,
      required this.colorAlerta,
      required this.colorNormal});
}

sealed class Evento {}

class CambioAColor extends Evento {}

class cambioDeColorAlerta extends Evento {
  final Color colorAlerta;

  cambioDeColorAlerta({required this.colorAlerta});
}

class cambioDeColorNormal extends Evento {
  final Color colorNormal;

  cambioDeColorNormal({required this.colorNormal});
}

class YaInicializado extends Evento {}

class CambioANumero extends Evento {}

class CambioDeNumero extends Evento {
  late final int numeroInicial;

  CambioDeNumero({required this.numeroInicial});
}

enum Estados { numeroSeleccionado, colorSeleccionado, inicial }

class OpcionesBloc extends Bloc<Evento, Estados> {
  late final SharedPreferencesAsync prefs;
  Datos datos = Datos(numeroInicial: 0, colorAlerta: '', colorNormal: '');
  OpcionesBloc() : super(Estados.inicial) {
    on<CambioAColor>((event, emit) async {
      String colorAlerta = await prefs.getString(_colorDeAlerta) ?? '';
      String colorNormal = await prefs.getString(_colorNormal) ?? '';
      datos.colorAlerta = colorAlerta;
      datos.colorNormal = colorNormal;
      emit(Estados.colorSeleccionado);
    });
    on<CambioANumero>((event, emit) {
      emit(Estados.numeroSeleccionado);
    });
    on<CambioDeNumero>(
      (event, emit) {
        prefs.setInt(_numeroInicial, event.numeroInicial);
        datos.numeroInicial = event.numeroInicial;
      },
    );
    on<YaInicializado>((event, emit) async {
      prefs = SharedPreferencesAsync();
      int numero = await prefs.getInt(_numeroInicial) ?? 0;
      datos.numeroInicial = numero;
      emit(Estados.numeroSeleccionado);
    });
    on<cambioDeColorAlerta>((event, emit) {
      Color color = event.colorAlerta;
      String colorString = '#${color.value.toRadixString(16).substring(2)}';
      prefs.setString(_colorDeAlerta, colorString);
      datos.colorAlerta = colorString;
      emit(Estados.colorSeleccionado);
    });
    on<cambioDeColorNormal>((event, emit) {
      Color color = event.colorNormal;
      String colorString = '#${color.value.toRadixString(16).substring(2)}';
      prefs.setString(_colorNormal, colorString);
      datos.colorNormal = colorString;
      emit(Estados.colorSeleccionado);
    });
  }
}
