import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String numeroInicial = 'numeroinicial';

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

class cambioDeColor extends Evento {
  final String colorAlerta;
  final String colorNormal;

  cambioDeColor({required this.colorAlerta, required this.colorNormal});
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
      int numero = await prefs.getInt(numeroInicial) ?? 0;
      datos.numeroInicial = numero;
      emit(Estados.numeroSeleccionado);
    });
  }
}
