import 'package:flutter/material.dart';
import '../models/block.dart';

class TowerPainter extends CustomPainter {
  final List<Block> stackedBlocks;
  final Block currentBlock;
  final double cameraOffsetY;

  TowerPainter({
    required this.stackedBlocks,
    required this.currentBlock,
    required this.cameraOffsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, cameraOffsetY);

    for (var block in stackedBlocks) {
      _drawBlock(canvas, block);
    }

    _drawBlock(canvas, currentBlock);

    canvas.restore();
  }

  void _drawBlock(Canvas canvas, Block block) {
    final rect = Rect.fromLTWH(block.x, block.y, block.width, block.height);

    final paintGlow = Paint()
      ..color = block.color.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final paintBlock = Paint()
      ..color = block.color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(rect, paintGlow);
    canvas.drawRect(rect, paintBlock);
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant TowerPainter oldDelegate) => true;
}
