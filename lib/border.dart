import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

class Boundary extends BodyComponent {
  final Vector2 start;
  final Vector2 end;

  Boundary(this.start, this.end, {Paint? paint}) : super(paint: paint);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..userData = 'border'
      ..restitution = 0.0
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
