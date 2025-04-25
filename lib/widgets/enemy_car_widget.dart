import 'package:flutter/material.dart';

class EnemyCarWidget extends StatelessWidget {
  final int type; // 1, 2 or 3

  const EnemyCarWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/enemy_$type.png';
    return Image.asset(imagePath, width: 60, height: 100);
  }
}
