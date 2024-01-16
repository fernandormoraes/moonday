import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:moonday_project/actors/astro_enemy.dart';
import 'package:moonday_project/actors/astro_player.dart';
import 'package:moonday_project/managers/segment_manager.dart';
import 'package:moonday_project/objects/ground_block.dart';
import 'package:moonday_project/objects/mars_background.dart';
import 'package:moonday_project/objects/platform_block.dart';
import 'package:moonday_project/overlays/hud.dart';

class MoondayGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late AstroPlayer _astro;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  double objectSpeed = 0.0;
  int health = 3;
  int score = 0;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'astro.png',
      'ground-mars.png',
      'heart.png',
      'enemy.png',
      'background.png',
      'bullet.png'
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;

    initializeGame(true);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          world.add(
            GroundBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case PlatformBlock:
          add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case AstroEnemy:
          world.add(
            AstroEnemy(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
      }
    }
  }

  void initializeGame(bool loadHud) {
    add(MarsBackground());
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _astro = AstroPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    world.add(_astro);

    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    health = 3;
    score = 0;
    initializeGame(false);
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }
}
