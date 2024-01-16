import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:moonday_project/moon_day.dart';
import 'package:moonday_project/shared/sprites.dart';

class MarsBackground extends ParallaxComponent<MoondayGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax([
      ParallaxImageData(Sprites.background),
    ],
        baseVelocity: Vector2(0, 0),
        velocityMultiplierDelta: Vector2(0, 0),
        repeat: ImageRepeat.noRepeat,
        fill: LayerFill.width);
  }
}
