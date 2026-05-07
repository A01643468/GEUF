import 'dart:async';
import 'dart:math';
import 'data_source.dart';

/// Genera una senal ECG sintetica para probar la app en el emulador.
/// Simula un ritmo cardiaco entre 65 y 85 BPM con una onda PQRST simplificada.
class DemoSource implements EcgDataSource {
  final _controller = StreamController<EcgData>.broadcast();
  Timer? _timer;

  int _sampleIndex = 0;
  int _bpm = 75;
  int _samplesPerBeat = 60;
  int _beatCounter = 0;

  final _random = Random();

  @override
  Stream<EcgData> get dataStream => _controller.stream;

  @override
  Future<bool> start() async {
    _timer?.cancel();
    // 50 Hz = una muestra cada 20ms (igual que el Arduino real)
    _timer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      _generateSample();
    });
    return true;
  }

  void _generateSample() {
    // Cada cierto tiempo cambiamos un poco el BPM (variabilidad cardiaca)
    _beatCounter++;
    if (_beatCounter > 200) {
      _beatCounter = 0;
      _bpm = 65 + _random.nextInt(20);  // 65-85 BPM
      _samplesPerBeat = (50 * 60) ~/ _bpm;
    }

    final ecg = _ecgWaveform(_sampleIndex, _samplesPerBeat);

    _controller.add(EcgData(
      ecg: ecg,
      bpm: _bpm,
      leadOn: true,
    ));

    _sampleIndex = (_sampleIndex + 1) % _samplesPerBeat;
  }

  /// Genera una onda PQRST simplificada en valores 0-1023
  int _ecgWaveform(int i, int total) {
    final t = i / total;
    double v = 512;  // baseline

    // Onda P
    if (t > 0.10 && t < 0.18) {
      v += 60 * sin((t - 0.10) / 0.08 * pi);
    }
    // Q
    else if (t > 0.20 && t < 0.22) {
      v -= 80;
    }
    // R (pico grande)
    else if (t > 0.22 && t < 0.26) {
      v += 400 * sin((t - 0.22) / 0.04 * pi);
    }
    // S
    else if (t > 0.26 && t < 0.30) {
      v -= 120 * sin((t - 0.26) / 0.04 * pi);
    }
    // T
    else if (t > 0.40 && t < 0.55) {
      v += 100 * sin((t - 0.40) / 0.15 * pi);
    }

    // Ruido para realismo
    v += (_random.nextDouble() - 0.5) * 10;

    return v.clamp(0, 1023).toInt();
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
