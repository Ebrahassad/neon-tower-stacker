import 'package:flutter/material.dart';

enum BlockType { normal, neon, magnetic, elastic, ecoWater, ecoForest }

class Block {
  double x;
  double y;
  double width;
  final double height;
  final Color color;
  final BlockType type;
  double rotation;

  Block({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
    this.type = BlockType.normal,
    this.rotation = 0.0,
  });
}
