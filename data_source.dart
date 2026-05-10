import 'dart:async';

/// Datos ECG que recibe la app desde cualquier fuente
class EcgData {
  final int ecg;       // valor ADC (0-1023 para Arduino UNO)
  final int bpm;
  final bool leadOn;
  EcgData({required this.ecg, required this.bpm, required this.leadOn});
}

/// Interfaz comun: tanto el modo Demo como el modo Bluetooth
/// la implementan, asi la pantalla principal no sabe de donde vienen los datos.
abstract class EcgDataSource {
  Stream<EcgData> get dataStream;

  /// Inicia la fuente. Para demo arranca el timer.
  /// Para bluetooth inicia la conexion (devuelve true si conecto).
  Future<bool> start();

  /// Detiene la fuente.
  Future<void> stop();

  void dispose();
}
