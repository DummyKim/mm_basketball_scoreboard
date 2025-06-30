import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Scoreboard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'DSEG7Classic'),
        ),
      ),
      home: const ScoreboardPage(),
    );
  }
}

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  static const Duration gameStartDuration = Duration(minutes: 10);
  static const Duration shotClockStartDuration = Duration(seconds: 24);

  Duration _gameTime = gameStartDuration;
  Duration _shotClock = shotClockStartDuration;
  Timer? _gameTimer;
  Timer? _shotClockTimer;

  int _homeScore = 0;
  int _awayScore = 0;

  int _homeFouls = 0;
  int _awayFouls = 0;

  String _homeName = 'HOME';
  String _awayName = 'AWAY';
  String _quarter = '1Q';

  void _startGameTimer() {
    if (_gameTimer?.isActive ?? false) return;
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameTime.inSeconds > 0) {
        setState(() {
          _gameTime -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _startShotClock() {
    if (_shotClockTimer?.isActive ?? false) return;
    _shotClockTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_shotClock.inSeconds > 0) {
        setState(() {
          _shotClock -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resetShotClock() {
    setState(() {
      _shotClockTimer?.cancel();
      _shotClock = shotClockStartDuration;
    });
  }

  void _setShotClock14() {
    setState(() {
      _shotClockTimer?.cancel();
      _shotClock = const Duration(seconds: 14);
    });
  }

  void _editTeamName(bool home) async {
    final controller = TextEditingController(text: home ? _homeName : _awayName);
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
      setState(() {
        if (home) {
          _homeName = result;
        } else {
          _awayName = result;
        }
      });
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerStyle = TextStyle(
      fontFamily: 'DSEG7Classic',
      color: Colors.red,
      fontSize: 80,
    );
    final TextStyle shotStyle = TextStyle(
      fontFamily: 'DSEG7Classic',
      color: Colors.yellow,
      fontSize: 60,
    );
    final TextStyle scoreStyle = TextStyle(
      fontFamily: 'DSEG7Classic',
      color: Colors.white,
      fontSize: 80,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _teamColumn(true, scoreStyle),
                GestureDetector(
                  onTap: _startGameTimer,
                  child: Text(
                    _formatDuration(_gameTime),
                    style: timerStyle,
                  ),
                ),
                _teamColumn(false, scoreStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _startShotClock,
                  child: Text(
                    _shotClock.inSeconds.toString().padLeft(2, '0'),
                    style: shotStyle,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(onPressed: _setShotClock14, child: const Text('14s')),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _resetShotClock, child: const Text('Reset')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PopupMenuButton<String>(
                  initialValue: _quarter,
                  onSelected: (val) => setState(() => _quarter = val),
                  itemBuilder: (context) => ['1Q', '2Q', '3Q', '4Q', 'OT']
                      .map((e) => PopupMenuItem(value: e, child: Text(e)))
                      .toList(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Quarter: $_quarter'),
                  ),
                ),
                const SizedBox(width: 50),
                _foulCounter(true),
                const SizedBox(width: 30),
                _foulCounter(false),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamColumn(bool home, TextStyle scoreStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _editTeamName(home),
          child: Text(
            home ? _homeName : _awayName,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() {
                if (home) {
                  if (_homeScore > 0) _homeScore--;
                } else {
                  if (_awayScore > 0) _awayScore--;
                }
              }),
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            Text(
              home ? _homeScore.toString().padLeft(3, '0') : _awayScore.toString().padLeft(3, '0'),
              style: scoreStyle,
            ),
            IconButton(
              onPressed: () => setState(() {
                if (home) {
                  _homeScore++;
                } else {
                  _awayScore++;
                }
              }),
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _foulCounter(bool home) {
    return Row(
      children: [
        Text('${home ? _homeName : _awayName} Fouls: ${home ? _homeFouls : _awayFouls}'),
        IconButton(
          onPressed: () => setState(() {
            if (home) {
              if (_homeFouls > 0) _homeFouls--;
            } else {
              if (_awayFouls > 0) _awayFouls--;
            }
          }),
          icon: const Icon(Icons.remove, color: Colors.white),
        ),
        IconButton(
          onPressed: () => setState(() {
            if (home) {
              _homeFouls++;
            } else {
              _awayFouls++;
            }
          }),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}
