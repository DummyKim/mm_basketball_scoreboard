import 'package:flutter/material.dart';

class TeamScore extends StatefulWidget {
  final String name;
  final ValueChanged<String>? onNameChanged;
  final TextStyle scoreStyle;
  const TeamScore({super.key, required this.name, this.onNameChanged, required this.scoreStyle});

  @override
  State<TeamScore> createState() => _TeamScoreState();
}

class _TeamScoreState extends State<TeamScore> {
  late String _name;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
  }

  void _editName() async {
    final controller = TextEditingController(text: _name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Team Name'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('OK')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _name = result);
      widget.onNameChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _editName,
          child: Text(
            _name,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.05,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() { if (_score > 0) _score--; }),
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            Text(
              _score.toString().padLeft(3, '0'),
              style: widget.scoreStyle,
            ),
            IconButton(
              onPressed: () => setState(() { _score++; }),
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
