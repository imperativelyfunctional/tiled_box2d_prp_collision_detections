import 'package:flame/components.dart';

enum CowState {
  idle,
  walk,
}

class CowSprite extends SpriteAnimationGroupComponent<CowState>
    with HasGameRef {
  CowSprite({
    required Vector2 size,
  }) : super(size: size, anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    final idle = await gameRef.loadSpriteAnimation(
      'cow.png',
      SpriteAnimationData.sequenced(
        texturePosition: Vector2(0, 0),
        amount: 3,
        textureSize: Vector2(32, 32),
        stepTime: 0.3,
        loop: true,
      ),
    );

    final walk = await gameRef.loadSpriteAnimation(
      'cow.png',
      SpriteAnimationData.sequenced(
        texturePosition: Vector2(0, 32),
        amount: 2,
        textureSize: Vector2(32, 32),
        stepTime: 0.3,
        loop: true,
      ),
    );

    animations = {
      CowState.idle: idle,
      CowState.walk: walk,
    };
    current = CowState.idle;
    return super.onLoad();
  }
}
