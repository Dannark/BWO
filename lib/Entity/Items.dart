import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Item extends Entity {
  Sprite sprite;

  double lifeTime = 0;
  Paint p = Paint();

  double alphaBlink = 1;
  double blinkTimeBeforeDelete = 0;

  Item(double x, double y, double z) : super(x, y) {
    super.z = z;
    bounciness = 0.12;
    lifeTime = GameController.time + 16;
    loadSprite();
  }

  void loadSprite() async {
    sprite = await Sprite.loadSprite("items/apple2.png");
  }

  @override
  void draw(Canvas c) {
    if (sprite != null) {
      if (GameController.time > lifeTime - 3) {
        blink(.08);
      } else if (GameController.time > lifeTime - 6) {
        blink(.2);
      }

      p.color = Color.fromRGBO(255, 255, 255, alphaBlink);

      sprite.renderPosition(c, Position(x - 8, y - 16 - z), overridePaint: p);
      updatePhysics();

      if (GameController.time > lifeTime) {
        destroy();
      }

      //debugDraw(c);
    }
  }

  void blink(double speed) {
    if (GameController.time > blinkTimeBeforeDelete) {
      blinkTimeBeforeDelete = GameController.time + speed;
      alphaBlink = alphaBlink < 1 ? 1 : .3;
    }
  }
}
