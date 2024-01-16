import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:moonday_project/moon_day.dart';
import 'package:moonday_project/shared/sprites.dart';

class PlatformBlock extends SpriteComponent with HasGameReference<MoondayGame> {
  final Vector2 velocity = Vector2.zero();
  final Vector2 gridPosition;
  double xOffset;

  PlatformBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  void onLoad() {
    final platformImage = game.images.fromCache(Sprites.block);
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
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
}
