import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'widgets/car_widget.dart';
import 'widgets/enemy_car_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double playerX = -1; // Left lane (-1), Right lane (1)
  double enemyX = 1;
  double enemyY = -1.2;

  int enemyType = 1; // 1, 2, or 3 for different enemy cars
  int score = 0;
  double speed = 0.01;
  bool isGameOver = false;

  Timer? gameTimer;

  void startGame() {
    isGameOver = false;
    score = 0;
    enemyY = -1.2;
    enemyX = Random().nextBool() ? -1 : 1;
    enemyType = Random().nextInt(3) + 1;
    speed = 0.01;

    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        enemyY += speed;

        // Respawn enemy when it goes off-screen
        if (enemyY >= 1.2) {
          enemyY = -1.2;
          enemyX = Random().nextBool() ? -1 : 1;
          enemyType = Random().nextInt(3) + 1;
          score += 100;

          if (score % 1000 == 0) {
            speed += 0.002; // Increase speed every 1000 points
          }
        }

        // Collision detection
        if (enemyX == playerX && enemyY > 0.7 && enemyY < 1.1) {
          isGameOver = true;
          gameTimer?.cancel();
        }
      });
    });
  }

  void moveLeft() {
    setState(() {
      playerX = -1;
    });
  }

  void moveRight() {
    setState(() {
      playerX = 1;
    });
  }

  void restartGame() {
    setState(() {
      playerX = -1;
      enemyX = 1;
      enemyY = -1.2;
      enemyType = 1;
      score = 0;
      speed = 0.01;
      isGameOver = false;
    });
    startGame();
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Stack(
          children: [
            // Score Display
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                'Score: $score',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            // Center Road
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 200,
                height: double.infinity,
                color: Colors.black,
              ),
            ),

            // Player Car
            AnimatedAlign(
              alignment: Alignment(playerX, 1),
              duration: const Duration(milliseconds: 200),
              child: const CarWidget(),
            ),

            // Enemy Car
            AnimatedAlign(
              alignment: Alignment(enemyX, enemyY),
              duration: const Duration(milliseconds: 0),
              child: EnemyCarWidget(type: enemyType),
            ),

            // Tap Left Half
            Positioned.fill(
              left: 0,
              right: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(onTap: moveLeft),
            ),

            // Tap Right Half
            Positioned.fill(
              left: MediaQuery.of(context).size.width / 2,
              right: 0,
              child: GestureDetector(onTap: moveRight),
            ),

            // Game Over Overlay
            if (isGameOver)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Game Over",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: restartGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Restart Game"),
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
