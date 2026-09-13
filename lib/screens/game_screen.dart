import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/block.dart';
import '../painters/tower_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  static const double blockHeight = 36.0;
  static const double initialWidth = 220.0;
  
  List<Block> stackedBlocks = [];
  late Block currentBlock;
  
  double direction = 1.0;
  double speed = 4.0;
  int score = 0;
  int combo = 0;
  bool isGameOver = false;
  double cameraOffsetY = 0.0;

  @override
  void initState() {
    super.initState();
    _resetGame();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_gameLoop);
    _controller.repeat();
  }

  void _resetGame() {
    setState(() {
      score = 0;
      combo = 0;
      isGameOver = false;
      cameraOffsetY = 0.0;
      speed = 4.0;
      stackedBlocks.clear();

      double screenWidth = 360.0;
      double baseY = 550.0;

      stackedBlocks.add(Block(
        x: (screenWidth - initialWidth) / 2,
        y: baseY,
        width: initialWidth,
        height: blockHeight,
        color: Colors.purpleAccent,
      ));

      _spawnNextBlock(baseY - blockHeight, initialWidth);
    });
  }

  void _spawnNextBlock(double y, double width) {
    final types = BlockType.values;
    final randomType = types[Random().nextInt(types.length)];

    Color color;
    switch (randomType) {
      case BlockType.neon:
        color = Colors.cyanAccent;
        break;
      case BlockType.magnetic:
        color = Colors.deepPurpleAccent;
        break;
      case BlockType.elastic:
        color = Colors.amberAccent;
        break;
      default:
        color = Colors.pinkAccent;
    }

    currentBlock = Block(
      x: 0,
      y: y,
      width: width,
      height: blockHeight,
      color: color,
      type: randomType,
    );
  }

  void _gameLoop() {
    if (isGameOver) return;

    setState(() {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth == 0) screenWidth = 360.0;

      currentBlock.x += speed * direction;

      if (currentBlock.x + currentBlock.width >= screenWidth) {
        direction = -1.0;
      } else if (currentBlock.x <= 0) {
        direction = 1.0;
      }
    });
  }

  void _dropBlock() {
    if (isGameOver) {
      _resetGame();
      return;
    }

    Block lastBlock = stackedBlocks.last;
    double diff = currentBlock.x - lastBlock.x;

    if (currentBlock.type == BlockType.magnetic && diff.abs() < 35) {
      currentBlock.x = lastBlock.x;
      diff = 0;
    }

    if (diff.abs() < 7.0) {
      currentBlock.x = lastBlock.x;
      diff = 0;
      combo++;
      score += 15 * combo;
    } else {
      combo = 0;
      score += 5;
    }

    double newWidth = currentBlock.width - diff.abs();

    if (newWidth <= 0) {
      setState(() {
        isGameOver = true;
      });
      return;
    }

    double newX = diff > 0 ? currentBlock.x : lastBlock.x;

    if (currentBlock.type == BlockType.elastic) {
      newWidth = min(initialWidth, newWidth + 20);
    }

    Block placedBlock = Block(
      x: newX,
      y: currentBlock.y,
      width: newWidth,
      height: blockHeight,
      color: currentBlock.color,
      type: currentBlock.type,
    );

    stackedBlocks.add(placedBlock);

    if (placedBlock.y + cameraOffsetY < 300) {
      cameraOffsetY += blockHeight;
    }

    speed += 0.2;
    _spawnNextBlock(placedBlock.y - blockHeight, newWidth);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080511),
      body: GestureDetector(
        onTap: _dropBlock,
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: TowerPainter(
                stackedBlocks: stackedBlocks,
                currentBlock: currentBlock,
                cameraOffsetY: cameraOffsetY,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SCORE: $score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (combo > 1)
                      Text(
                        '${combo}x PERFECT!',
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isGameOver)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF140D2B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'GAME OVER',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Final Score: $score',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tap Anywhere to Restart',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
