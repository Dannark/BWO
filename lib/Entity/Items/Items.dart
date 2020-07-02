import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Items/ItemDatabase.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Item extends Entity {
  ItemDB proprieties;
  Sprite sprite;

  double lifeTime = 0;
  Paint p = Paint();

  double alphaBlink = 1;
  double blinkTimeBeforeDelete = 0;

  int amount = 1;

  Item(double x, double y, double z, this.proprieties) : super(x, y) {
    super.z = z;
    bounciness = 0.12;
    lifeTime = GameController.time + 16;
    loadSprite();
    shadownSize = proprieties.zoom;

    isCollisionTrigger = true; //make item to be pickedUp
  }

  void loadSprite() async {
    sprite = await Sprite.loadSprite(proprieties.imgPath);
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

      Offset pivot =
          Offset((proprieties.zoom * 16) / 2, (proprieties.zoom * 16));
      sprite.renderScaled(c, Position(x - pivot.dx, y - pivot.dy - z),
          scale: proprieties.zoom, overridePaint: p);
      updatePhysics();

      if (GameController.time > lifeTime) {
        destroy();
      }

      //debugDraw(c);
    }
  }

  void use(Entity entity) {
    if (proprieties.useEffects) {
      amount--;
      entity.status.addLife(proprieties.hp);
      entity.status.addEnergy(proprieties.energy);
      Flame.audio.play("items/eating_apple.mp3", volume: 0.3);
    }
  }

  void blink(double speed) {
    if (GameController.time > blinkTimeBeforeDelete) {
      blinkTimeBeforeDelete = GameController.time + speed;
      alphaBlink = alphaBlink < 1 ? 1 : .3;
    }
  }
}
