import 'package:box2d_collision_rpg_style/border.dart';
import 'package:box2d_collision_rpg_style/cow.dart';
import 'package:box2d_collision_rpg_style/player.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_camera.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiled/tiled.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(GameWidget(
    game: Box2dCollisionDemo(),
  ));
}

const scaleFactor = 10.0;
const double mapHeight = 320;
const double velocity = 20;

class Box2dCollisionDemo extends Forge2DGame with HasKeyboardHandlerComponents {
  Box2dCollisionDemo() : super(gravity: Vector2(0, 0), zoom: scaleFactor);

  late Player player;
  double x = 0;
  double y = 160;

  @override
  Future<void> onLoad() async {
    var effectiveSize = camera.viewport.effectiveSize;
    camera.viewport = FixedResolutionViewport(
        Vector2(effectiveSize.x * mapHeight / effectiveSize.y, mapHeight));

    var map =
        await TiledComponent.load('level.tmx', Vector2.all(16 / scaleFactor));
    add(map);

    var positions = (map.tileMap.getLayer('positions') as ObjectGroup).objects;
    for (var element in positions) {
      if (element.type == 'spawn') {
        player = Player(Vector2(element.x, element.y) / scaleFactor)
          ..priority = 1;
        await add(player);
        camera.followBodyComponent(player);
      } else if (element.type == 'cow_spawn_small') {
        add(CowSprite(size: Vector2(32, 32) / scaleFactor / 1.1)
          ..flipHorizontally()
          ..position = Vector2(element.x, element.y) / scaleFactor);
      } else if (element.type == 'cow_moving') {
        var cowSprite = CowSprite(size: Vector2(32, 32) / scaleFactor)
          ..position = Vector2(element.x, element.y) / scaleFactor;
        await add(cowSprite);
        cowSprite.current = CowState.walk;
        cowSprite.add(ColorEffect(Colors.red.withOpacity(0.8), const Offset(0.1, 0.3),
            EffectController(infinite: true, duration: 1)));
      } else {
        add(CowSprite(size: Vector2(32, 32) / scaleFactor)
          ..position = Vector2(element.x, element.y) / scaleFactor);
      }
    }

    var borders = (map.tileMap.getLayer('borders') as ObjectGroup).objects;
    for (var element in borders) {
      var width = element.width / scaleFactor;
      var height = element.height / scaleFactor;
      var x = element.x / scaleFactor;
      var y = element.y / scaleFactor;
      final start = Vector2(x, y);
      var paint = Paint()..color = Colors.transparent;
      element.type.split('_').forEach((side) {
        switch (side) {
          case 'top':
            {
              add(Boundary(start, Vector2(x + width, y), paint: paint));
              break;
            }
          case 'bottom':
            {
              add(Boundary(
                  start + Vector2(0, height), Vector2(x + width, y + height),
                  paint: paint));
              break;
            }
          case 'left':
            {
              add(Boundary(start, Vector2(x, y + height), paint: paint));
              break;
            }
          case 'right':
            {
              add(Boundary(
                  start + Vector2(width, 0), Vector2(x + width, y + height),
                  paint: paint));
              break;
            }
          default:
            {
              break;
            }
        }
      });
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    var playerSprite = player.playerSprite;
    if (keysPressed.isNotEmpty) {
      if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
        playerSprite.current = PlayerDirection.left;
        player.body.linearVelocity = Vector2(-velocity, 0);
      } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
        playerSprite.current = PlayerDirection.right;
        player.body.linearVelocity = Vector2(velocity, 0);
      } else if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
        playerSprite.current = PlayerDirection.up;
        player.body.linearVelocity = Vector2(0, -velocity);
      } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
        playerSprite.current = PlayerDirection.down;
        player.body.linearVelocity = Vector2(0, velocity);
      }
    } else {
      player.body.linearVelocity = Vector2(0, 0);
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
