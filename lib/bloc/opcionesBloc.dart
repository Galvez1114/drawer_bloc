import 'package:drawer_bloc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String numeroInicial = 'numeroinicial';
const String saveColorNormal = 'numeroNormal';
const String saveColorAlerta = 'numeroAlerta';

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

class CambioDeColor extends Evento {
  final String colorAlerta;
  final String colorNormal;

  CambioDeColor({required this.colorAlerta, required this.colorNormal});
}

class YaInicializado extends Evento {}

class CambioANumero extends Evento {}

class CambioDeNumero extends Evento {
  late final int numeroInicial;

  CambioDeNumero({required this.numeroInicial});
}

//Los "selecionados" es el cambio entre opciones que muestran los distintos ouputs.
enum Estados { numeroSeleccionado, colorSeleccionado, inicial }

class OpcionesBloc extends Bloc<Evento, Estados> {
  late final SharedPreferencesAsync prefs;
  Datos datos = Datos(numeroInicial: 0, colorAlerta: '', colorNormal: '000000');
  OpcionesBloc() : super(Estados.inicial) {
    on<CambioAColor>((event, emit) {
      emit(Estados.colorSeleccionado);
    });
    on<CambioANumero>((event, emit) {
      emit(Estados.numeroSeleccionado);
    });
    on<CambioDeNumero>(
      (event, emit) {
        prefs.setInt(numeroInicial, event.numeroInicial);
        datos.numeroInicial = event.numeroInicial;
      },
    );
    on<YaInicializado>((event, emit) async {
      prefs = SharedPreferencesAsync();
      //Obtener el número inicial...
      int numero = await prefs.getInt(numeroInicial) ?? 0;
      datos.numeroInicial = numero;

      //Obtener colores iniciales...
      Color saveNormalValue =
          (await prefs.getString(saveColorNormal) ?? '').toColor() ??
              Colors.blue;
      Color saveAlertaValue =
          (await prefs.getString(saveColorAlerta) ?? '').toColor() ??
              Colors.blue;

      datos.colorNormal = saveNormalValue.toHexString();
      datos.colorAlerta = saveAlertaValue.toHexString();

      emit(Estados.numeroSeleccionado);
    });
    on<CambioDeColor>((event, emit) {
      prefs.setString(saveColorNormal, event.colorNormal);
      prefs.setString(saveColorAlerta, event.colorAlerta);
      datos.colorNormal = event.colorNormal;
      datos.colorAlerta = event.colorAlerta;
      emit(Estados.colorSeleccionado);
    });
  }
}
