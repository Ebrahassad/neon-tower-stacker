import 'package:flutter/material.dart';

enum WorldType { neonPulse, stormDefense, beatStacker, zeroGravity, ecoBiomes }

class WorldModel {
  final WorldType type;
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;

  WorldModel({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
  });

  static List<WorldModel> getAllWorlds() {
    return [
      WorldModel(
        type: WorldType.neonPulse,
        title: "1. عالم الخامات النيون",
        description: "طوابق مغناطيسية ومطاطية تتفاعل مع بعضها بسرعة عالية.",
        icon: Icons.flash_on,
        primaryColor: Colors.purpleAccent,
        accentColor: Colors.cyanAccent,
      ),
      WorldModel(
        type: WorldType.stormDefense,
        title: "2. عالم العواصف",
        description: "تحدَّ رياح العاصفة والهزات الأرضية التي تحرك البرج.",
        icon: Icons.air,
        primaryColor: Colors.deepOrangeAccent,
        accentColor: Colors.amberAccent,
      ),
      WorldModel(
        type: WorldType.beatStacker,
        title: "3. العالم الإيقاعي",
        description: "اسقط الطوابق بالتزامن مع النبضات الموسيقية لتحصل على نقاط مضاعفة.",
        icon: Icons.music_note,
        primaryColor: Colors.pinkAccent,
        accentColor: Colors.lightGreenAccent,
      ),
      WorldModel(
        type: WorldType.zeroGravity,
        title: "4. انعدام الجاذبية",
        description: "البرج يدور ويميل في الفضاء مع كل طابق تحطه عليه.",
        icon: Icons.blur_circular,
        primaryColor: Colors.indigoAccent,
        accentColor: Colors.blueAccent,
      ),
      WorldModel(
        type: WorldType.ecoBiomes,
        title: "5. الجزر البيئية",
        description: "اطبق بيئات متوافقة (ماء + غابة) لإطلاق جذور تثبيت خضراء.",
        icon: Icons.eco,
        primaryColor: Colors.greenAccent,
        accentColor: Colors.tealAccent,
      ),
    ];
  }
}
