import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:moonday_project/actors/astro_enemy.dart';
import 'package:moonday_project/moon_day.dart';
import 'package:moonday_project/objects/bullet.dart';
import 'package:moonday_project/objects/ground_block.dart';
import 'package:moonday_project/objects/platform_block.dart';
import 'package:moonday_project/shared/sprites.dart';

class AstroPlayer extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks, HasGameReference<MoondayGame> {
  int horizontalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  final double gravity = 10;
  final double jumpSpeed = 600;
  final double terminalVelocity = 150;

  bool hasJumped = false;
  bool hitByEnemy = false;
  bool hasShot = false;

  AstroPlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(Sprites.astro),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(32),
        stepTime: 0.12,
      ),
    );

    add(CircleHitbox());
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.arrowUp);

    hasShot = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    game.objectSpeed = 0;

    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }

    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    // Apply basic gravity
    velocity.y += gravity;

    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = false;
    }

    if (hasShot) {
      _shoot();

      hasShot = false;
    }

    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);
    position += velocity * dt;

    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    if (game.health <= 0) {
      removeFromParent();
    }

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is AstroEnemy) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }

  void _shoot() {
    Bullet b = Bullet(xdir: scale.x, position: position);
    parent!.add(b);
  }
}
