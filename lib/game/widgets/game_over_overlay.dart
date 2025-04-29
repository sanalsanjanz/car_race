import 'package:car_race/game/car_race.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(),
              ),
              const WhiteSpace(height: 50),
              GameScoreDisplay(game: game, isLight: true),
              const WhiteSpace(height: 50),
              ElevatedButton(
                onPressed: () {
                  (game as CarRace).resetGame();
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(const Size(200, 75)),
                  textStyle: WidgetStateProperty.all(
                    Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
