import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final gameController = TextEditingController(text: '10:00');
  final shotController = TextEditingController(text: '24');

  @override
  void dispose() {
    gameController.dispose();
    shotController.dispose();
    super.dispose();
  }

  Duration? _parse(String value) {
    final parts = value.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]);
      final seconds = int.tryParse(parts[1]);
      if (minutes != null && seconds != null) {
        return Duration(minutes: minutes, seconds: seconds);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Timers')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: gameController,
              decoration: const InputDecoration(labelText: 'Game Clock (mm:ss)'),
            ),
            TextField(
              controller: shotController,
              decoration: const InputDecoration(labelText: 'Shot Clock (seconds)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'game': _parse(gameController.text),
                  'shot': int.tryParse(shotController.text),
                });
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
