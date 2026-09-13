import 'dart:math';
import 'package:flutter/material.dart';
import '../models/block.dart';
import '../models/world.dart';

class TowerPainter extends CustomPainter {
  final List<Block> stackedBlocks;
  final Block currentBlock;
  final double cameraOffsetY;
  final WorldModel world;
  final double windOffset;
  final double beatScale;

  TowerPainter({
    required this.stackedBlocks,
    required this.currentBlock,
    required this.cameraOffsetY,
    required this.world,
    this.windOffset = 0.0,
    this.beatScale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    _drawBackgroundEffects(canvas, size);
    canvas.translate(0, cameraOffsetY);

    for (int i = 0; i < stackedBlocks.length; i++) {
      var block = stackedBlocks[i];
      double currentWind = (world.type == WorldType.stormDefense) ? windOffset * (i / 5.0) : 0.0;
      
      canvas.save();
      canvas.translate(currentWind, 0);
      _drawBlock(canvas, block);
      canvas.restore();
    }

    _drawBlock(canvas, currentBlock, isCurrent: true);
    canvas.restore();
  }

  void _drawBackgroundEffects(Canvas canvas, Size size) {
    if (world.type == WorldType.beatStacker) {
      final pulsePaint = Paint()
        ..color = world.accentColor.withOpacity(0.15 * beatScale)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 120 * beatScale, pulsePaint);
    } else if (world.type == WorldType.stormDefense) {
      final windLine = Paint()
        ..color = Colors.white10
        ..strokeWidth = 1.5;
      for (int i = 0; i < 6; i++) {
        double y = (i * 120 + windOffset * 10) % size.height;
        canvas.drawLine(Offset(0, y), Offset(size.width, y + 20), windLine);
      }
    }
  }

  void _drawBlock(Canvas canvas, Block block, {bool isCurrent = false}) {
    canvas.save();

    if (block.rotation != 0.0) {
      canvas.translate(block.x + block.width / 2, block.y + block.height / 2);
      canvas.rotate(block.rotation);
      canvas.translate(-(block.x + block.width / 2), -(block.y + block.height / 2));
    }

    final rect = Rect.fromLTWH(block.x, block.y, block.width, block.height);

    final paintGlow = Paint()
      ..color = block.color.withOpacity(0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isCurrent ? 14 : 8);

    final paintBlock = Paint()
      ..color = block.color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(rect, paintGlow);
    canvas.drawRect(rect, paintBlock);
    canvas.drawRect(rect, borderPaint);

    if (block.type == BlockType.ecoForest) {
      final leafPaint = Paint()..color = Colors.greenAccent;
      canvas.drawCircle(Offset(block.x + 10, block.y), 6, leafPaint);
      canvas.drawCircle(Offset(block.x + block.width - 10, block.y), 6, leafPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TowerPainter oldDelegate) => true;
}
