import 'dart:async';

import 'package:car_race/game/car_race.dart';
import 'package:car_race/game/sprites/competitor.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { left, right, center }

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<CarRace>, KeyboardHandler, CollisionCallbacks {
  Player({required this.character, this.moveLeftRightSpeed = 700})
    : super(
        size: Vector2(100, 150),
        anchor: Anchor.center,
        priority: 1,
      ); // Increased size

  double moveLeftRightSpeed;
  Character character;

  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  Vector2 _velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await add(CircleHitbox(radius: size.x / 2)); // Adjust hitbox size
    await _loadCharacterSprites();

    if (sprites != null) {
      current = PlayerState.center;
    } else {
      print('Error: Sprites are not loaded correctly.');
    }
  }

  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    _velocity.x = _hAxisInput * moveLeftRightSpeed;

    final double marioHorizontalCenter = size.x / 2;

    if (position.x < marioHorizontalCenter) {
      position.x = gameRef.size.x - (marioHorizontalCenter);
    }
    if (position.x > gameRef.size.x - (marioHorizontalCenter)) {
      position.x = marioHorizontalCenter;
    }

    position += _velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Print collision points for debugging
    print(
      'Collision detected with ${other.runtimeType} at points: $intersectionPoints',
    );

    // Check if the colliding component is an enemy car
    if (other is EnemyPlatform) {
      gameRef.onLose();
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }

    return true;
  }

  void moveLeft() {
    _hAxisInput = 0;

    current = PlayerState.left;

    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0; // by default not going left or right

    current = PlayerState.right;

    _hAxisInput += movingRightInput;
  }

  void resetDirection() {
    _hAxisInput = 0;
  }

  void reset() {
    _velocity = Vector2.zero();
    if (sprites != null) {
      current = PlayerState.center;
    } else {
      print('Error: Sprites are not loaded correctly in reset method.');
    }
  }

  void resetPosition() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      (gameRef.size.y - size.y) / 2,
    );
  }

  Future<void> _loadCharacterSprites() async {
    final left = await gameRef.loadSprite('${character.name}.png');
    final right = await gameRef.loadSprite('${character.name}.png');
    final center = await gameRef.loadSprite('${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.center: center,
    };

    print('Sprites loaded successfully: $sprites');
  }
}
