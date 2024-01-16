import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:moonday_project/moon_day.dart';
import 'package:moonday_project/objects/bullet.dart';
import 'package:moonday_project/shared/sprites.dart';

class AstroEnemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<MoondayGame> {
  final Vector2 gridPosition;
  double xOffset;

  final Vector2 velocity = Vector2.zero();

  AstroEnemy({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(Sprites.enemy),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(32),
        stepTime: 0.70,
      ),
    );
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
    add(
      MoveEffect.by(
        Vector2(-2 * size.x, 0),
        EffectController(
          duration: 3,
          alternate: true,
          infinite: true,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;

    if (position.x < -size.x || game.health <= 0) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      game.score += 1;
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}
