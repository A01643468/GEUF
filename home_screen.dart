import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// Modulos del integrante 2 (comunicacion)
import 'data_source.dart';
import 'demo_source.dart';
import 'bluetooth_source.dart';

// Modulo del integrante 4 (logica clinica)
import 'recommendation.dart';

// UI del integrante 3
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DemoSource _demo = DemoSource();
  final BluetoothSource _bluetooth = BluetoothSource();
  EcgDataSource? _activeSource;
  StreamSubscription<EcgData>? _sub;

  bool _useBluetooth = false;
  bool _connected = false;

  final List<FlSpot> _ecgPoints = [];
  int _bpm = 0;
  bool _leadOn = true;
  double _xValue = 0;

  int _userAge = 25;
  String _userSex = 'M';

  @override
  void initState() {
    super.initState();
    _switchToDemo();
  }

  void _onData(EcgData data) {
    setState(() {
      _bpm = data.bpm;
      _leadOn = data.leadOn;
      _xValue += 1;
      _ecgPoints.add(FlSpot(_xValue, data.ecg.toDouble()));
      if (_ecgPoints.length > 100) {
        _ecgPoints.removeAt(0);
      }
    });
  }

  Future<void> _switchToDemo() async {
    await _stopActive();
    _activeSource = _demo;
    _sub = _demo.dataStream.listen(_onData);
    await _demo.start();
    setState(() {
      _useBluetooth = false;
      _connected = true;
    });
  }

  Future<void> _switchToBluetooth() async {
    await _stopActive();
    setState(() {
      _useBluetooth = true;
      _connected = false;
      _ecgPoints.clear();
      _bpm = 0;
    });
  }

  Future<void> _stopActive() async {
    await _sub?.cancel();
    _sub = null;
    if (_activeSource != null) {
      await _activeSource!.stop();
      _activeSource = null;
    }
  }

  Future<void> _connectBluetooth() async {
    final devices = await _bluetooth.getPairedDevices();

    if (devices.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay dispositivos emparejados. Empareja el HC-05 primero.')),
        );
      }
      return;
    }

    if (!mounted) return;

    final selected = await showDialog<BluetoothDevice>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Selecciona el HC-05'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: devices.length,
            itemBuilder: (_, i) => ListTile(
              leading: const Icon(Icons.bluetooth),
              title: Text(devices[i].name ?? 'Sin nombre'),
              subtitle: Text(devices[i].address),
              onTap: () => Navigator.pop(ctx, devices[i]),
            ),
          ),
        ),
      ),
    );

    if (selected == null) return;

    _bluetooth.selectDevice(selected.address);
    _activeSource = _bluetooth;
    _sub = _bluetooth.dataStream.listen(_onData);
    final ok = await _bluetooth.start();

    setState(() => _connected = ok);

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo conectar al HC-05')),
      );
    }
  }

  Color _bpmColor() {
    if (_bpm == 0) return Colors.grey;
    final cat = Recommendation.classify(_bpm, _userAge);
    return cat.color;
  }

  @override
  Widget build(BuildContext context) {
    final recommendation = Recommendation.getMessage(
      bpm: _bpm,
      age: _userAge,
      leadOn: _leadOn,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Monitor'),
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    age: _userAge,
                    sex: _userSex,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  _userAge = result['age'];
                  _userSex = result['sex'];
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: SwitchListTile(
                title: Text(_useBluetooth ? 'Modo Bluetooth (HC-05)' : 'Modo Demo (datos simulados)'),
                subtitle: Text(_useBluetooth
                    ? 'Conexion a hardware real'
                    : 'Ideal para emulador'),
                value: _useBluetooth,
                activeColor: Colors.red.shade400,
                onChanged: (v) {
                  if (v) {
                    _switchToBluetooth();
                  } else {
                    _switchToDemo();
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      '$_bpm',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: _bpmColor(),
                      ),
                    ),
                    const Text('BPM', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _ecgPoints.isEmpty
                      ? const Center(child: Text('Sin senal'))
                      : LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: 1023,
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _ecgPoints,
                                isCurved: false,
                                color: Colors.red,
                                barWidth: 2,
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.health_and_safety, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (_useBluetooth)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _connected ? null : _connectBluetooth,
                  icon: Icon(_connected ? Icons.bluetooth_connected : Icons.bluetooth),
                  label: Text(_connected ? 'Conectado' : 'Conectar al HC-05'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopActive();
    _demo.dispose();
    _bluetooth.dispose();
    super.dispose();
  }
}
