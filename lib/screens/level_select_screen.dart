import 'package:flutter/material.dart';
import '../models/world.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final worlds = WorldModel.getAllWorlds();

    return Scaffold(
      backgroundColor: const Color(0xFF080511),
      appBar: AppBar(
        title: const Text('العوالم والمراحل'),
        backgroundColor: const Color(0xFF140D2B),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: worlds.length,
        itemBuilder: (context, index) {
          final world = worlds[index];
          return Card(
            color: const Color(0xFF140D2B),
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: world.primaryColor, width: 1.5),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: world.primaryColor.withOpacity(0.2),
                child: Icon(world.icon, color: world.accentColor, size: 30),
              ),
              title: Text(
                world.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  world.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen(world: world)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
