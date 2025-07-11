import 'package:flutter/material.dart';

class FoulCounter extends StatefulWidget {
  final String teamName;
  const FoulCounter({super.key, required this.teamName});

  @override
  State<FoulCounter> createState() => _FoulCounterState();
}

class _FoulCounterState extends State<FoulCounter> {
  int _fouls = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${widget.teamName} Fouls: $_fouls',
          style: const TextStyle(color: Colors.white),
        ),
        IconButton(
          onPressed: () => setState(() { if (_fouls > 0) _fouls--; }),
          icon: const Icon(Icons.remove, color: Colors.white),
        ),
        IconButton(
          onPressed: () => setState(() { _fouls++; }),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}
