import 'dart:async';
import 'dart:ui'; // Needed for Rect

import 'package:car_race/game/background.dart';
import 'package:car_race/game/managers/game_manager.dart';
import 'package:car_race/game/managers/object_manager.dart';
import 'package:car_race/game/sprites/competitor.dart';
import 'package:car_race/game/sprites/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

enum Character { bmw, farari, lambo, tarzen, tata, tesla }

class CarRace extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  CarRace({super.children});

  final BackGround _backGround = BackGround();
  final GameManager gameManager = GameManager();
  ObjectManager objectManager = ObjectManager();
  int screenBufferSpace = 300;

  EnemyPlatform platFrom = EnemyPlatform();

  late Player player;

  @override
  FutureOr<void> onLoad() async {
    await add(_backGround);
    await add(gameManager);
    overlays.add('gameOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameManager.isGameOver) {
      return;
    }
    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }
    if (gameManager.isPlaying) {
      final top = camera.viewfinder.position.y - screenBufferSpace;
      final height = _backGround.size.y + screenBufferSpace;
      final bounds = Rect.fromLTWH(
        0,
        top,
        size.x,
        height,
      ); // Use Rect instead of Rectangle
      // camera.setBounds(bounds as Shape?); // Pass the Rect to setBounds
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void setCharacter() {
    player = Player(character: gameManager.character, moveLeftRightSpeed: 600);
    add(player);
  }

  void initializeGameStart() {
    setCharacter();
    gameManager.reset();

    if (children.contains(objectManager)) {
      objectManager.removeFromParent();
    }

    player.reset();

    final top = -_backGround.size.y;
    final height = _backGround.size.y + screenBufferSpace;
    final cameraBounds = Rect.fromLTWH(0, top, size.x, height);
    // camera.setBounds(cameraBounds as Shape?);

    camera.follow(player); // use `follow`, not `followComponent`

    player.resetPosition();

    objectManager = ObjectManager();
    add(objectManager);
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();

    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }
}
