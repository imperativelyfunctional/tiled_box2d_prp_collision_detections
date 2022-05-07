import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'main.dart';

enum PlayerDirection {
  up,
  down,
  left,
  right,
}

class Player extends BodyComponent {
  final Vector2 position;
  late PlayerSprite playerSprite;

  Player(this.position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    playerSprite = PlayerSprite(size: Vector2(48, 48) / scaleFactor)
      ..anchor = Anchor.center;
    add(playerSprite);
    body.setFixedRotation(true);
  }

  @override
  Body createBody() {
    var bodyDef = BodyDef();
    bodyDef.position.setFrom(position);
    bodyDef.type = BodyType.dynamic;

    var bodyFixtureDef = FixtureDef(PolygonShape()
      ..setAsBox(
          8 / scaleFactor, 9 / scaleFactor, Vector2(0, 0) / scaleFactor, 0))
      ..restitution = 0
      ..friction = 0
      ..density = 0;
    var body = world.createBody(bodyDef);
    body.createFixture(bodyFixtureDef);
    return body;
  }
}

class PlayerSprite extends SpriteAnimationGroupComponent<PlayerDirection>
    with HasGameRef {
  PlayerSprite({
    required Vector2 size,
  }) : super(size: size);

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    final down = await gameRef.loadSpriteAnimation(
      'character.png',
      SpriteAnimationData.sequenced(
        texturePosition: Vector2(0, 0),
        amount: 4,
        textureSize: Vector2(48, 48),
        stepTime: 0.3,
        loop: true,
      ),
    );

    final up = await gameRef.loadSpriteAnimation(
      'character.png',
      SpriteAnimationData.sequenced(
        texturePosition: Vector2(0, 48),
        amount: 4,
        textureSize: Vector2(48, 48),
        stepTime: 0.3,
        loop: true,
      ),
    );

    final left = await gameRef.loadSpriteAnimation(
      'character.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(48, 48),
        texturePosition: Vector2(0, 96),
        stepTime: 0.3,
      ),
    );

    final right = await gameRef.loadSpriteAnimation(
      'character.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(48, 48),
        texturePosition: Vector2(0, 144),
        stepTime: 0.3,
        loop: true,
      ),
    );

    animations = {
      PlayerDirection.up: up,
      PlayerDirection.down: down,
      PlayerDirection.left: left,
      PlayerDirection.right: right,
    };
    current = PlayerDirection.right;
    return super.onLoad();
  }
}
