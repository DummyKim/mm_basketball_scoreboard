import 'package:flutter/material.dart';
import 'clock.dart';
import 'teamScore.dart';
import 'foulCounter.dart';
import 'settings.dart';
import 'edit.dart';
import 'quarter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _homeName = 'HOME';
  String _awayName = 'AWAY';
  Duration _gameStart = const Duration(minutes: 10);
  Duration _shotStart = const Duration(seconds: 24);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final scoreStyle = TextStyle(
      fontFamily: 'DSEG7Classic',
      color: Colors.white,
      fontSize: height * 0.15,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.push<Map<String, dynamic>?>(
                          context,
                          MaterialPageRoute(builder: (_) => const EditPage()),
                        );
                        if (result != null) {
                          setState(() {
                            _gameStart = result['game'] ?? _gameStart;
                            _shotStart = Duration(seconds: result['shot'] ?? _shotStart.inSeconds);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 50,
              child: Center(
                child: GameClock(
                  key: ValueKey('game-\${_gameStart.inSeconds}'),
                  start: _gameStart,
                  fontSizeFactor: 0.3,
                ),
              ),
            ),
            Expanded(
              flex: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TeamScore(
                        name: _homeName,
                        onNameChanged: (v) => setState(() => _homeName = v),
                        scoreStyle: scoreStyle,
                      ),
                      FoulCounter(teamName: _homeName),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShotClock(
                        key: ValueKey('shot-\${_shotStart.inSeconds}'),
                        start: _shotStart,
                        fontSizeFactor: 0.2,
                      ),
                      const SizedBox(height: 10),
                      const QuarterSelector(),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TeamScore(
                        name: _awayName,
                        onNameChanged: (v) => setState(() => _awayName = v),
                        scoreStyle: scoreStyle,
                      ),
                      FoulCounter(teamName: _awayName),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
