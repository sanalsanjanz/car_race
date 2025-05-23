import 'package:car_race/game/car_race.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScoreDisplay extends StatelessWidget {
  const GameScoreDisplay({super.key, required this.game, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as CarRace).gameManager.score,
      builder: (context, value, child) {
        return Text(
          'Score: $value',
          style: Theme.of(context).textTheme.displaySmall!,
        );
      },
    );
  }
}
