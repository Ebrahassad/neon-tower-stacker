import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const NeonTowerApp());
}

class NeonTowerApp extends StatelessWidget {
  const NeonTowerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Tower Stacker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}
