import 'package:flutter/material.dart';
import 'clock.dart';
import 'teamScore.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _homeName = 'HOME';
  String _awayName = 'AWAY';

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
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 50,
              child: Center(
                child: GameClock(
                  start: const Duration(minutes: 10),
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
                  TeamScore(
                    name: _homeName,
                    onNameChanged: (v) => setState(() => _homeName = v),
                    scoreStyle: scoreStyle,
                  ),
                  ShotClock(
                    start: const Duration(seconds: 24),
                    fontSizeFactor: 0.2,
                  ),
                  TeamScore(
                    name: _awayName,
                    onNameChanged: (v) => setState(() => _awayName = v),
                    scoreStyle: scoreStyle,
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
