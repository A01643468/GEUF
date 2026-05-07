import 'package:flutter/material.dart';

void main() => runApp(const ImcApp());

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ImcHome(),
    );
  }
}

class ImcHome extends StatefulWidget {
  const ImcHome({super.key});

  @override
  State<ImcHome> createState() => _ImcHomeState();
}

class _ImcHomeState extends State<ImcHome> {
  final _peso = TextEditingController();
  final _altura = TextEditingController();
  double? _imc;
  String _categoria = '';

  void _calcular() {
    final peso = double.tryParse(_peso.text);
    final alturaCm = double.tryParse(_altura.text);
    if (peso == null || alturaCm == null || alturaCm == 0) return;

    final alturaM = alturaCm / 100;
    final imc = peso / (alturaM * alturaM);

    setState(() {
      _imc = imc;
      if (imc < 18.5) {
        _categoria = 'Bajo peso';
      } else if (imc < 25) {
        _categoria = 'Peso normal';
      } else if (imc < 30) {
        _categoria = 'Sobrepeso';
      } else {
        _categoria = 'Obesidad';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _peso,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _altura,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Estatura (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Calcular'),
              ),
            ),
            const SizedBox(height: 32),
            if (_imc != null) ...[
              Text(
                _imc!.toStringAsFixed(2),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Text(
                _categoria,
                style: const TextStyle(fontSize: 22, color: Colors.teal),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
