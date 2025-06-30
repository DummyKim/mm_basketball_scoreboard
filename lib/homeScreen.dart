import 'package:flutter/material.dart';
import 'clock.dart';
import 'teamScore.dart';
import 'foulCounter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _homeName = 'HOME';
  String _awayName = 'AWAY';
  String _quarter = '1Q';

  @override
  Widget build(BuildContext context) {
    final scoreStyle = TextStyle(
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
                TeamScore(
                  name: _homeName,
                  onNameChanged: (v) => setState(() => _homeName = v),
                  scoreStyle: scoreStyle,
                ),
                const GameClock(start: Duration(minutes: 10)),
                TeamScore(
                  name: _awayName,
                  onNameChanged: (v) => setState(() => _awayName = v),
                  scoreStyle: scoreStyle,
                ),
              ],
            ),
            const ShotClock(start: Duration(seconds: 24)),
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
                FoulCounter(teamName: _homeName),
                const SizedBox(width: 30),
                FoulCounter(teamName: _awayName),
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
}
