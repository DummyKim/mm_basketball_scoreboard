import 'dart:async';
import 'package:flutter/material.dart';

class GameClock extends StatefulWidget {
  final Duration start;
  final double fontSizeFactor;
  const GameClock({super.key, required this.start, this.fontSizeFactor = 0.3});

  @override
  State<GameClock> createState() => _GameClockState();
}

class _GameClockState extends State<GameClock> {
  late Duration _time;
  Timer? _timer;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _time = widget.start;
  }

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_time.inSeconds > 0) {
          setState(() => _time -= const Duration(seconds: 1));
        } else {
          timer.cancel();
        }
      });
      setState(() => _running = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * widget.fontSizeFactor;
    final style = TextStyle(
      fontFamily: 'DSEG7Classic',
      color: Colors.red,
      fontSize: size,
    );
    return GestureDetector(
      onTap: _toggle,
      child: Text(
        _format(_time),
        style: style,
      ),
    );
  }
}

class ShotClock extends StatefulWidget {
  final Duration start;
  final double fontSizeFactor;
  const ShotClock({super.key, required this.start, this.fontSizeFactor = 0.2});

  @override
  State<ShotClock> createState() => _ShotClockState();
}

class _ShotClockState extends State<ShotClock> {
  late Duration _time;
  Timer? _timer;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _time = widget.start;
  }

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_time.inSeconds > 0) {
          setState(() => _time -= const Duration(seconds: 1));
        } else {
          timer.cancel();
        }
      });
      setState(() => _running = true);
    }
  }

  void _reset([Duration? to]) {
    setState(() {
      _timer?.cancel();
      _running = false;
      _time = to ?? widget.start;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * widget.fontSizeFactor;
    final style = TextStyle(
      fontFamily: 'DSEG7Classic',
      color: Colors.yellow,
      fontSize: size,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _toggle,
          child: Text(
            _time.inSeconds.toString().padLeft(2, '0'),
            style: style,
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => _reset(const Duration(seconds: 14)),
          child: const Text(
            '14s',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _reset,
          child: const Text(
            'Reset',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
