import 'dart:async';

import 'package:car_race/game/car_race.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class BackGround extends ParallaxComponent<CarRace> with HasGameRef<CarRace> {
  double backgroundSpeed = 2;

  @override
  FutureOr<void> onLoad() async {
    // Call super.onLoad() to initialize the component properly, including gameRef
    await super.onLoad();

    // Now that the component is initialized, we can access gameRef
    parallax = await gameRef.loadParallax(
      [ParallaxImageData('road1.png'), ParallaxImageData('road1.png')],
      fill: LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -70 * backgroundSpeed),
      velocityMultiplierDelta: Vector2(0, 1.2 * backgroundSpeed),
    );
  }
}
