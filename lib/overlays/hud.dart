import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moonday_project/moon_day.dart';

import 'heart.dart';

class Hud extends PositionComponent with HasGameReference<MoondayGame> {
  late TextComponent _scoreTextComponent;

  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  @override
  Future<void> onLoad() async {
    _scoreTextComponent = TextComponent(
      text: 'Score: ${game.score}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Colors.orange,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 20),
    );
    add(_scoreTextComponent);

    for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = 'Score: ${game.score}';
  }
}
