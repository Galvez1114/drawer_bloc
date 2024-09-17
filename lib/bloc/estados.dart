class Datos {
  final int numeroInicial;
  final String colorAlerta;
  final String colorNormal;

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

class cambioANumero extends Evento {}

class cambioDeNumero extends Evento {
  final int numeroInicial;

  cambioDeNumero({required this.numeroInicial});
}
