import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sound = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Sound'),
              value: sound,
              onChanged: (v) => setState(() => sound = v),
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: vibration,
              onChanged: (v) => setState(() => vibration = v),
            ),
          ],
        ),
      ),
    );
  }
}
