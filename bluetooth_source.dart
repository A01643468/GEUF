import 'dart:async';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'data_source.dart';

/// Fuente de datos real: se conecta al HC-05 por Bluetooth Clasico.
/// Solo funciona en celulares Android reales.
class BluetoothSource implements EcgDataSource {
  BluetoothConnection? _connection;
  String _buffer = '';
  String? _selectedAddress;

  final _controller = StreamController<EcgData>.broadcast();

  @override
  Stream<EcgData> get dataStream => _controller.stream;

  Future<List<BluetoothDevice>> getPairedDevices() async {
    return await FlutterBluetoothSerial.instance.getBondedDevices();
  }

  void selectDevice(String address) {
    _selectedAddress = address;
  }

  @override
  Future<bool> start() async {
    if (_selectedAddress == null) return false;

    try {
      _connection = await BluetoothConnection.toAddress(_selectedAddress!);

      _connection!.input!.listen((data) {
        _buffer += utf8.decode(data, allowMalformed: true);

        while (_buffer.contains('\n')) {
          final idx = _buffer.indexOf('\n');
          final line = _buffer.substring(0, idx).trim();
          _buffer = _buffer.substring(idx + 1);

          final parsed = _parse(line);
          if (parsed != null) _controller.add(parsed);
        }
      }).onDone(() {
        print('HC-05 desconectado');
      });

      return true;
    } catch (e) {
      print('Error al conectar: $e');
      return false;
    }
  }

  EcgData? _parse(String message) {
    try {
      final parts = message.split(',');
      int ecg = 0;
      int bpm = 0;
      bool leadOn = true;

      for (final p in parts) {
        final kv = p.split(':');
        if (kv.length != 2) continue;
        switch (kv[0]) {
          case 'ECG':
            ecg = int.tryParse(kv[1]) ?? 0;
            break;
          case 'BPM':
            bpm = int.tryParse(kv[1]) ?? 0;
            break;
          case 'LEAD':
            leadOn = kv[1] == 'ON';
            break;
        }
      }
      return EcgData(ecg: ecg, bpm: bpm, leadOn: leadOn);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> stop() async {
    await _connection?.close();
    _connection = null;
    _buffer = '';
  }

  @override
  void dispose() {
    _connection?.dispose();
    _controller.close();
  }
}
