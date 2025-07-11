import 'package:flutter/material.dart';

class QuarterSelector extends StatefulWidget {
  const QuarterSelector({super.key});

  @override
  State<QuarterSelector> createState() => _QuarterSelectorState();
}

class _QuarterSelectorState extends State<QuarterSelector> {
  final List<String> _quarters = ['1Q', '2Q', '3Q', '4Q', 'OT'];
  int _index = 0;

  void _next() {
    setState(() => _index = (_index + 1) % _quarters.length);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _next,
      child: Text(
        _quarters[_index],
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.height * 0.05,
        ),
      ),
    );
  }
}
