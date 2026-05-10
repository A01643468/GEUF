import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final int age;
  final String sex;

  const ProfileScreen({super.key, required this.age, required this.sex});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _ageCtrl;
  late String _sex;

  @override
  void initState() {
    super.initState();
    _ageCtrl = TextEditingController(text: widget.age.toString());
    _sex = widget.sex;
  }

  void _save() {
    final age = int.tryParse(_ageCtrl.text) ?? 25;
    Navigator.pop(context, {'age': age, 'sex': _sex});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Datos demograficos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            TextField(
              controller: _ageCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cake),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Sexo'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Masculino'),
                    value: 'M',
                    groupValue: _sex,
                    onChanged: (v) => setState(() => _sex = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Femenino'),
                    value: 'F',
                    groupValue: _sex,
                    onChanged: (v) => setState(() => _sex = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
