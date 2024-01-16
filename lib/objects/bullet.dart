import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:moonday_project/actors/astro_player.dart';
import 'package:moonday_project/moon_day.dart';
import 'package:moonday_project/shared/sprites.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameRef<MoondayGame>, CollisionCallbacks {
  double xdir;
  Bullet({super.position, super.size, required this.xdir});
  final double _speed = 500;
  final Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    animation = _createSpriteAnimation();
    add(RectangleHitbox(collisionType: CollisionType.active));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    velocity.x = xdir * _speed;
    position.x += velocity.x * dt;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is! AstroPlayer) {
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  SpriteAnimation _createSpriteAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(Sprites.bullet),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.50,
        textureSize: Vector2.all(8),
      ),
    );
  }
}
